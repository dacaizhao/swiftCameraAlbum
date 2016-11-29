//
//  TakePicListCollectionView.swift
//  swiftCameraAlbum
//
//  Created by point on 2016/11/28.
//  Copyright © 2016年 dacai. All rights reserved.
//

import UIKit

private let kCellID = "kCellID"

class TakePicListCollectionView: UICollectionView {
    
    var imgArr = [UIImage]() {
        didSet {
            self.reloadData()
            scrollToBottom()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dataSource = self
        delegate = self
        self.backgroundColor = UIColor.black
        //self.register(UINib(nibName: "TakePicListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: kCellID)
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsetsMake(0 , 0, 0, 0)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    fileprivate func scrollToBottom(){
        if self.imgArr.count < 1 { return } else {
            let lastIndexPath = NSIndexPath(item: self.imgArr.count-1, section: 0)
            
            self.scrollToItem(at: lastIndexPath as IndexPath, at: .right, animated: true)
            
        }
    }
    
}




// MARK:- 原生代理
extension TakePicListCollectionView: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imgArr.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellID, for: indexPath) as! TakePicListCollectionViewCell
        let img = imgArr[indexPath.item]
        cell.img.image =  img
        return cell
    }
}
