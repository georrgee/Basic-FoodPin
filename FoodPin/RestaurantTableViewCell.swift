//
//  RestaurantTableViewCell.swift
//  FoodPin
//
//  Created by George Garcia on 10/23/17.
//  Copyright © 2017 Gee Team. All rights reserved.
//  Committing now... 10/26

import UIKit

class RestaurantTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var thumbnailImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
