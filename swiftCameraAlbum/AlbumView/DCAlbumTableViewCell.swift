//
//  DCAlbumTableViewCell.swift
//  Chihiro
//
//  Created by point on 2016/11/7.
//  Copyright © 2016年 chihiro. All rights reserved.
//

import UIKit

class DCAlbumTableViewCell: UITableViewCell {

    @IBOutlet weak var albumName: UILabel!
  
    @IBOutlet weak var albumNumLabel: UILabel!
    override func awakeFromNib() {
       
        super.awakeFromNib()
        
        albumName.text = "相册名称"
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
