//
//  ViewController.swift
//  swiftCameraAlbum
//
//  Created by point on 2016/11/28.
//  Copyright © 2016年 dacai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var cameraView: UIView! //相机显示
    @IBOutlet weak var focusView: UIImageView! //聚焦图片
    @IBOutlet weak var takePicListCollectionView: TakePicListCollectionView!//展示列表
    fileprivate var imgArr: [UIImage] = [UIImage]() //拍照的图片
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //启动照相机
        DCCameraAlbum.shareCamera.start(view: cameraView, frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height-150))
        
        //设置聚焦图片
        DCCameraAlbum.shareCamera.focusView = focusView
        
    }
    
    
    
    @IBAction func getAlbumListClick(_ sender: UIButton) {
        
    }
  
    
    // MARK:- 拍摄照片
    @IBAction func takePicClick(_ sender: UIButton) {
       
        DCCameraAlbum.shareCamera.takePhoto { [unowned self] (image) in
            self.imgArr.append(image)
            self.takePicListCollectionView.imgArr = self.imgArr
            
        }
    }
    
    // MARK:- 闪光灯管理
    @IBAction func flashSegment(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            DCCameraAlbum.shareCamera.flashLamp(mode: .auto)
        case 1:
            DCCameraAlbum.shareCamera.flashLamp(mode: .on)
        case 2:
            DCCameraAlbum.shareCamera.flashLamp(mode: .off)
        default:
            break
        }
    }
    
    
    
}

