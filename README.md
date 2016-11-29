# swiftCameraAlbum 你可以用它来完成任何样式的相机与相册 
### 为了兼容9.0 所以暂时未使用10.0的方法

![](https://github.com/dacaizhao/swiftCameraAlbum/blob/master/swiftCameraAlbum/Assets.xcassets/zhaodacai.imageset/zhaodacai.png?raw=true)

###启动照相机
######DCCameraAlbum.shareCamera.start(view: cameraView, frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height-150))

###设置聚焦图片
######DCCameraAlbum.shareCamera.focusView = focusView

###拍摄图片
######DCCameraAlbum.shareCamera.takePhoto { [unowned self] (image) in }

###获取图片库
######DCCameraAlbum.shareCamera.getAlbumItem()

###闪光灯管理
######DCCameraAlbum.shareCamera.flashLamp(mode: .auto)

###获取的默认相册 需要一点时间开销 所以回调完成
######DCCameraAlbum.shareCamera.getAlbumItemFetchResultsDefault(thumbnailSize: size) { (imgarr) in}

###获取的指定相册  需要一点时间开销 所以回调完成
######let itemArr = DCCameraAlbum.shareCamera.getAlbumItem()
######let resulet  = itemArr.first?.fetchResult
######let size = CGSize(width: 100, height: 100)
######DCCameraAlbum.shareCamera.getAlbumItemFetchResults(assetsFetchResults: resulet!, thumbnailSize: size) { [unowned self] (imgarr) in }

###获取单张图片信息
######DCCameraAlbum.shareCamera.getOriginalPicture

###还有相机相册权限判断等 你可以自己去看一下,很简单!




