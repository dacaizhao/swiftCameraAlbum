//
//  TakePicListCollectionViewCell.swift
//  swiftCameraAlbum
//
//  Created by point on 2016/11/28.
//  Copyright © 2016年 dacai. All rights reserved.
//

import UIKit

class TakePicListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var img: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        img.backgroundColor = UIColor.red
    }

}
