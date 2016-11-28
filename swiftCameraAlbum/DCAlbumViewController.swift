//
//  DCAlbumViewController.swift
//  Chihiro
//
//  Created by point on 2016/11/7.
//  Copyright © 2016年 chihiro. All rights reserved.
//

import UIKit
import Photos

private let kDCAlbumCellID = "kDCAlbumCellID"



class DCAlbumViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var dcAlbumItem = [DCAlbumItem]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    fileprivate lazy var tableView : UITableView = { [unowned self] in
        let tableView = UITableView(frame: CGRect.zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "DCAlbumTableViewCell", bundle: nil), forCellReuseIdentifier: kDCAlbumCellID)
        return tableView
        }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    
    
}

// MARK:- 设置UI
extension DCAlbumViewController {
    fileprivate func setupUI(){
        navigationItem.title = "相册"
        view.addSubview(tableView)
        tableView.frame = view.bounds
        
        
        let btn = UIButton()
        btn.setTitle("退出", for: .normal)
        btn.frame = CGRect(x: 100, y:kScreenH-100 , width: 100, height: 100)
        tableView.addSubview(btn)
        btn.backgroundColor = UIColor.red
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
    }
    
    @objc fileprivate func btnClick() {
        dismiss(animated: true, completion: nil)
    }
    
}


// MARK:- 代理
extension DCAlbumViewController {
    @objc(numberOfSectionsInTableView:) func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dcAlbumItem.count
    }
    
    @objc(tableView:cellForRowAtIndexPath:) func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kDCAlbumCellID, for: indexPath) as! DCAlbumTableViewCell
        let item = self.dcAlbumItem[indexPath.row]
        cell.albumName.text = item.title
        cell.albumNumLabel.text = String(item.fetchResult.count)
        return cell
    }
    
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let vc = DCAlbumListViewController()
        //        //获取选中的相簿信息
        //        let item = self.items[indexPath.row]
        //
        //        vc.assetsFetchResults = item.fetchResult
        //
        //        navigationController?.pushViewController(vc, animated: true)
    }
    
}
