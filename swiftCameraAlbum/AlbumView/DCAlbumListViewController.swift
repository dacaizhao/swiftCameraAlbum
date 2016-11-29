//
//  DCAlbumListViewController.swift
//  Chihiro
//
//  Created by point on 2016/11/7.
//  Copyright © 2016年 chihiro. All rights reserved.
//

import UIKit
import Photos

private let kDCAlbumListCellID = "kDCAlbumListCellID"
private let kCellWidth = kScreenW/4


class DCAlbumListViewController: UIViewController {
    
    var imgArr = [UIImage]() {
        didSet {
            collectionView.reloadData()
            
        }
    }
    
    
    
    // MARK:- 懒加载属性
    lazy var collectionView : UICollectionView = {[unowned self] in
        // 1.创建布局
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kCellWidth, height: kCellWidth)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        // 2.创建UICollectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        
        collectionView.dataSource  = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        
        collectionView.register(UINib(nibName: "DCAlbumCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: kDCAlbumListCellID)
        return collectionView
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        
        let btn = UIButton()
        btn.setTitle("退出", for: .normal)
        btn.frame = CGRect(x: 100, y:kScreenH-100 , width: 100, height: 100)
        view.addSubview(btn)
        btn.backgroundColor = UIColor.red
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
    }
    
    @objc fileprivate func btnClick() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
}



extension DCAlbumListViewController : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kDCAlbumListCellID, for: indexPath) as! DCAlbumCollectionViewCell
        cell.backgroundColor = UIColor.gray
        cell.albumImage.image = imgArr[indexPath.row]
        
        return cell
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
}

