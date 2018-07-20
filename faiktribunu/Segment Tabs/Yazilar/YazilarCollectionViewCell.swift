//
//  YazilarCollectionViewCell.swift
//  faiktribunu
//
//  Created by Halil İbrahim YÜCE on 27.06.2018.
//  Copyright © 2018 Halil İbrahim YÜCE. All rights reserved.
//

import UIKit
import SDWebImage

class YazilarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var haberGorseli: UIImageView!
    @IBOutlet weak var yazarAvatar: UIImageView!
    @IBOutlet weak var baslik: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    

}
