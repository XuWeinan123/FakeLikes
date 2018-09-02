//
//  WeiBoLikesDetailLikesCell.swift
//  FakeLikes
//
//  Created by 徐炜楠 on 2018/4/3.
//  Copyright © 2018年 徐炜楠. All rights reserved.
//

import UIKit

class WeiBoLikesDetailLikesCell: UITableViewCell {
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var nameLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width/2
        avatarImageView.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
