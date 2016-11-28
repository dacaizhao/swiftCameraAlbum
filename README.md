# swiftCameraAlbum

#//启动照相机
#DCCameraAlbum.shareCamera.start(view: cameraView, frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height-150))

#//设置聚焦图片
#DCCameraAlbum.shareCamera.focusView = focusView

#//拍摄图片
#DCCameraAlbum.shareCamera.takePhoto { [unowned self] (image) in }

#//获取图片库
#DCCameraAlbum.shareCamera.getAlbumItem()

#//闪光灯管理
#DCCameraAlbum.shareCamera.flashLamp(mode: .auto)

#//获取指定的相册 需要一定回调时间 //默认的就是第一个
#//DCCameraAlbum.shareCamera.getAlbumItemFetchResultsDefault(thumbnailSize: <#T##CGSize#>, finishedCallback: <#T##([UIImage]) -> ()#>)

#//你还可以这样做 你可以查看任何一个相册  需要一定的等待时间 所以是回调
#let itemArr = DCCameraAlbum.shareCamera.getAlbumItem()
#let resulet  = itemArr.first?.fetchResult
#let size = CGSize(width: 100, height: 100)
#DCCameraAlbum.shareCamera.getAlbumItemFetchResults(assetsFetchResults: resulet!, thumbnailSize: size) { [unowned self] (imgarr) in }

#//获取单张图片信息 等
#自己去看代码吧




