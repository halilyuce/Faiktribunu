//
//  BildirimlerTableViewCell.swift
//  faiktribunu
//
//  Created by Mac on 21.07.2018.
//  Copyright © 2018 Halil İbrahim YÜCE. All rights reserved.
//

import UIKit

class BildirimlerTableViewCell: UITableViewCell {
    @IBOutlet weak var resim: UIImageView!
    @IBOutlet weak var baslik: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
