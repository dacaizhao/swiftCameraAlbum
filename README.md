# swiftCameraAlbum
![](https://github.com/dacaizhao/swiftCameraAlbum/blob/master/swiftCameraAlbum/Assets.xcassets/zhaodacai.imageset/zhaodacai.png?raw=true)

//启动照相机
#DCCameraAlbum.shareCamera.start(view: cameraView, frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height-150))

//设置聚焦图片
#DCCameraAlbum.shareCamera.focusView = focusView

//拍摄图片
#DCCameraAlbum.shareCamera.takePhoto { [unowned self] (image) in }

//获取图片库
#DCCameraAlbum.shareCamera.getAlbumItem()

//闪光灯管理
#DCCameraAlbum.shareCamera.flashLamp(mode: .auto)

//获取的默认相册 需要一点时间开销
#//DCCameraAlbum.shareCamera.getAlbumItemFetchResultsDefault(thumbnailSize: <#T##CGSize#>, finishedCallback: <#T##([UIImage]) -> ()#>)

//获取的指定相册 需要一点时间开销
#let itemArr = DCCameraAlbum.shareCamera.getAlbumItem()
#let resulet  = itemArr.first?.fetchResult
#let size = CGSize(width: 100, height: 100)
#DCCameraAlbum.shareCamera.getAlbumItemFetchResults(assetsFetchResults: resulet!, thumbnailSize: size) { [unowned self] (imgarr) in }


#获取单张图片信息等 权限判断等 自己去看代码吧




