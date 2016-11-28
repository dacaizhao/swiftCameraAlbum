//
//  DCCameraAlbum.swift
//  DCCameraAlbum
//
//  Created by point on 2016/11/28.
//  Copyright © 2016年 dacai. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}

enum flashMode:Int {
    case off
    case on
    case auto
}

class DCCameraAlbum: NSObject {
    
    // MARK:- 相机属性
    fileprivate lazy var session : AVCaptureSession = AVCaptureSession()
    fileprivate lazy var inputDevice : AVCaptureDeviceInput = AVCaptureDeviceInput() //输入源
    fileprivate lazy var imageOutput : AVCaptureStillImageOutput = AVCaptureStillImageOutput() //输出
    lazy var priviewLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer() //视
    fileprivate var currentView: UIView! //管理控制器
    fileprivate var isUsingBackCamera:Bool = true //是否正在使用后置摄像头
    fileprivate var videoInput : AVCaptureDeviceInput?
    fileprivate var currentD :AVCaptureDevice!
    var focusView :UIView! //聚焦的View
    fileprivate var effectiveScale:CGFloat = 1.0 //默认缩放
    fileprivate var beginGestureScale:CGFloat = 1.0 //
    fileprivate let maxScale:CGFloat = 2.0 //最大缩放
    fileprivate let minScale:CGFloat = 1.0 //最小缩放
    
    // MARK:- 相册属性
    fileprivate var dCAlbumItems:[DCAlbumItem] = [] //相册列表
    fileprivate var imageManager:PHCachingImageManager! //带缓存的图片管理对象
    
    //单例
    internal static let shareCamera:DCCameraAlbum = {
        let camera = DCCameraAlbum()
        return camera
    }()
    
    //初始化
    override init() {
        super.init()
        if Platform.isSimulator {
            print("请不要使用模拟器测试")
        }
        else {
            installCameraDevice() //初始化摄像机
            
        }
    }
}

// MARK:- =============相册
class DCAlbumItem {
    //相簿名称
    var title:String?
    //相簿内的资源
    var fetchResult:PHFetchResult<PHAsset>
    init(title:String?,fetchResult:PHFetchResult<PHAsset>){
        self.title = title
        self.fetchResult = fetchResult
    }
}

// MARK: - 获取相册集合
extension DCCameraAlbum {
    // MARK: - 获取指定图片
    func getOriginalPicture(picAsset:PHAsset , finishedCallback: @escaping (_ image: UIImage) -> ()) {
        PHImageManager.default().requestImage(for: picAsset,
                                              targetSize: PHImageManagerMaximumSize , contentMode: .aspectFit,
                                              options: nil, resultHandler: {
                                                (image, _: [AnyHashable: Any]?) in
                                                finishedCallback(image!)
        })
    }
    
    // MARK: - 获取指定的相册缩略图列表
    func getAlbumItemFetchResults(assetsFetchResults: PHFetchResult<PHAsset> , thumbnailSize: CGSize , finishedCallback: @escaping (_ result : [UIImage] ) -> ()){
        cachingImageManager()
        let imageArr = fetchImage(assetsFetchResults: assetsFetchResults, thumbnailSize: thumbnailSize)
        finishedCallback(imageArr)
    }
    
    // MARK: - 获取默认的照相机照片缩略图列表
    func getAlbumItemFetchResultsDefault(thumbnailSize: CGSize , finishedCallback: @escaping (_ result : [UIImage] ) -> ()) {
        cachingImageManager()
        let allPhotosOptions = PHFetchOptions()
        //按照创建时间倒序排列
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",ascending: false)]
        //只获取图片
        allPhotosOptions.predicate = NSPredicate(format: "mediaType = %d",PHAssetMediaType.image.rawValue)
        let assetsFetchResults = PHAsset.fetchAssets(with: .image, options: allPhotosOptions)
        let imageArr = fetchImage(assetsFetchResults: assetsFetchResults, thumbnailSize: thumbnailSize)
        finishedCallback(imageArr)
        
    }
    
    //缓存管理
    fileprivate func cachingImageManager(){
        imageManager = PHCachingImageManager()
        imageManager.stopCachingImagesForAllAssets()
    }
    
    //获取图片
    fileprivate func fetchImage(assetsFetchResults:  PHFetchResult<PHAsset> , thumbnailSize: CGSize) -> [UIImage] {
        var imageArr:[UIImage] = []
        for i in 0..<assetsFetchResults.count {
            print(i)
            let asset = assetsFetchResults[i]
            self.imageManager.requestImage(for: asset, targetSize: thumbnailSize,
                                           contentMode: PHImageContentMode.aspectFill,
                                           options: nil) { (image, nfo) in
                                            imageArr.append(image!)
            }
        }
        return imageArr
    }
    
}
// MARK: - 获取相册列表
extension DCCameraAlbum {
    func getAlbumItem() -> [DCAlbumItem]{
        dCAlbumItems.removeAll()
        let smartOptions = PHFetchOptions()
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                                                                  subtype: PHAssetCollectionSubtype.albumRegular,
                                                                  options: smartOptions)
        self.convertCollection(smartAlbums as! PHFetchResult<AnyObject>)
        
        //列出所有用户创建的相册
        let userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        self.convertCollection(userCollections as! PHFetchResult<AnyObject>)
        
        //相册按包含的照片数量排序（降序）
        self.dCAlbumItems.sort { (item1, item2) -> Bool in
            return item1.fetchResult.count > item2.fetchResult.count
        }
        return dCAlbumItems
        
    }
    
    //转化处理获取到的相簿
    fileprivate func convertCollection(_ collection:PHFetchResult<AnyObject>){
        
        for i in 0..<collection.count{
            //获取出但前相簿内的图片
            let resultsOptions = PHFetchOptions()
            resultsOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                               ascending: false)]
            resultsOptions.predicate = NSPredicate(format: "mediaType = %d",
                                                   PHAssetMediaType.image.rawValue)
            guard let c = collection[i] as? PHAssetCollection else { return }
            let assetsFetchResult = PHAsset.fetchAssets(in: c,options: resultsOptions)
            //没有图片的空相簿不显示
            if assetsFetchResult.count > 0{
                self.dCAlbumItems.append(DCAlbumItem(title: c.localizedTitle, fetchResult: assetsFetchResult ))
            }
        }
    }
}

// MARK:- =============相机
// MARK: - 开始
extension DCCameraAlbum {
    func start(view: UIView , frame: CGRect){
        currentView = view
        addPrviewLayerToView(frame: frame)
        setUpGesture() //添加手势
        if session.isRunning == false {
            session.startRunning() //不要用,模拟器测试-_-!
        }
    }
}

// MARK: - 结束
extension DCCameraAlbum {
    func stop(){
        if session.isRunning == true {
            session.stopRunning()
        }
    }
}

// MARK: - 拍照
extension DCCameraAlbum {
    func takePhoto(finishedCallback :  @escaping (_ result : UIImage ) -> ()){
        let captureConnetion = imageOutput.connection(withMediaType: AVMediaTypeVideo)
        captureConnetion?.videoScaleAndCropFactor = effectiveScale
        imageOutput.captureStillImageAsynchronously(from: captureConnetion) { (imageBuffer, error) in
            let jpegData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageBuffer)
            let jpegImage = UIImage(data: jpegData!)
            //图片入库
            UIImageWriteToSavedPhotosAlbum(jpegImage!, self,nil, nil)
            finishedCallback(jpegImage!)
        }
    }
}

// MARK: - 闪光灯
extension DCCameraAlbum {
    func flashLamp(mode:flashMode){
        do{ try currentD.lockForConfiguration() }catch{ }
        if currentD.hasFlash == false { return }
        if mode.rawValue == 0 { currentD.flashMode = .off}
        if mode.rawValue == 1 { currentD.flashMode = .on}
        if mode.rawValue == 2 { currentD.flashMode = .auto}
        
        currentD.unlockForConfiguration()
    }
}

// MARK: - 前后摄像头
extension DCCameraAlbum {
    func beforeAfterCamera(){
        //获取之前的镜头
        guard var position = videoInput?.device.position else { return }
        //获取当前应该显示的镜头
        position = position == .front ? .back : .front
        //创建新的device
        guard let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) as? [AVCaptureDevice] else { return }
        // 1.2.取出获取前置摄像头
        let d = devices.filter({ return $0.position == position }).first
        currentD = d
        //input
        guard let videoInput = try? AVCaptureDeviceInput(device: d) else { return }
        
        //切换
        session.beginConfiguration()
        session.removeInput(self.videoInput!)
        session.addInput(videoInput)
        session.commitConfiguration()
        self.videoInput = videoInput
    }
}

// MARK: - 初始化相机相关
extension DCCameraAlbum:UIGestureRecognizerDelegate{
    
    fileprivate func installCameraDevice(){
        // 1.创建输入
        // 1.1.获取所有的设备（包括前置&后置摄像头）
        guard let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) as? [AVCaptureDevice] else { return }
        // 1.2.取出获取前置摄像头
        guard let d = devices.filter({ return $0.position == .back }).first else{ return}
        currentD = d
        // 1.3.通过前置摄像头创建输入设备
        guard let inputDevice = try? AVCaptureDeviceInput(device: d) else { return }
        self.videoInput = inputDevice
        
        //输出
        imageOutput = AVCaptureStillImageOutput()
        imageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
        
        
        //加入
        if session.canAddInput(inputDevice) == true {
            session.addInput(self.videoInput)
        }
        if session.canAddOutput(imageOutput) == true {
            session.addOutput(imageOutput)
        }
        
        //视图
        priviewLayer = AVCaptureVideoPreviewLayer(session:session)
        priviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        //闪光灯
        do{ try d.lockForConfiguration() }catch{ }
        if d.hasFlash == false { return }
        d.flashMode = AVCaptureFlashMode.on
        d.unlockForConfiguration()
    }
    
    //显示View
    fileprivate func addPrviewLayerToView(frame:CGRect) -> Void{
        priviewLayer.frame = frame
        //currentView.layer.masksToBounds = true
        currentView.layer.insertSublayer(priviewLayer, at: 0)
    }
    
    
    //添加手势 + 缩放 + 聚焦
    fileprivate func setUpGesture() {
        let pinGesutre = UIPinchGestureRecognizer(target: self, action: #selector(pinFunc(_:)))
        pinGesutre.delegate = self
        currentView.addGestureRecognizer(pinGesutre)
        
        let tapGesutre = UITapGestureRecognizer(target: self, action: #selector(tipFunc(_:)))
        currentView.addGestureRecognizer(tapGesutre)
    }
    
    //添加上聚焦
    @objc func tipFunc(_ ges:UITapGestureRecognizer) {
        let currentPoint  = ges.location(in: currentView)
        currentView.isUserInteractionEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            self.currentView.isUserInteractionEnabled = true
        }
        
        do{ try currentD.lockForConfiguration() }catch{ }
        if currentD.isFocusModeSupported(.autoFocus) {
            currentD.focusPointOfInterest = currentPoint
            currentD.focusMode = .autoFocus
        }
        if currentD.isExposureModeSupported(.autoExpose) {
            currentD.exposurePointOfInterest = currentPoint
            currentD.exposureMode = .autoExpose
        }
        currentD.unlockForConfiguration()
        focusView.center = currentPoint
        focusView.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.focusView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25);
        }) { (_) in
            UIView.animate(withDuration: 0.5, animations: {
                self.focusView.transform = CGAffineTransform.identity
            }) { (_) in
                self.focusView.isHidden = true
            }
        }
        
        
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer .isKind(of: UIPinchGestureRecognizer.classForCoder()) {
            beginGestureScale = self.effectiveScale
        }
        return true
    }
    
    //添加缩放
    @objc func pinFunc(_ recognizer:UIPinchGestureRecognizer) {
        self.effectiveScale = self.beginGestureScale * recognizer.scale;
        if (self.effectiveScale < 1.0) {
            self.effectiveScale = 1.0;
        }
        let maxScaleAndCropFactor = imageOutput.connection(withMediaType: AVMediaTypeVideo).videoMaxScaleAndCropFactor
        if  self.effectiveScale > maxScaleAndCropFactor {
            self.effectiveScale = maxScaleAndCropFactor;
        }
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.025)
        priviewLayer.setAffineTransform(CGAffineTransform(scaleX: effectiveScale, y: effectiveScale))
        CATransaction.commit()
    }
}

// MARK:- =============权限
extension DCCameraAlbum {
    //必须info.plist 配置上这2句
    //Privacy - Camera Usage Description
    //Privacy - Photo Library Usage Description
    /** 相机权限检测 */
    func cameraPermissions() -> Bool{
        let authStatus:AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        switch authStatus {
        case .denied , .restricted:
            return false
        case .authorized:
            return true
        case .notDetermined:
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: nil)
            return true
        }
    }
    
    /** 相册权限检测 */
    func photoPermissions() -> Bool{
        let authStatus:PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch authStatus {
        case .denied , .restricted:
            return false
        case .authorized:
            return true
        case .notDetermined:
            let vc = UIImagePickerController()
            vc.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            return true
        }
    }
}
