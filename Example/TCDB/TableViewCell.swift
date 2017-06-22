//
//  TableViewCell.swift
//  TCDB_Example
//
//  Created by 谈超 on 2017/6/22.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    var person : Person?{
        didSet{
            nameLabel.text = person?.name
            sexLabel.text = person?.sex == false ? "男":"女"
            phoneLabel.text = person?.phone
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var sexLabel: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
