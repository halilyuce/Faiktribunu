//
//  VideolarCollectionViewCell.swift
//  faiktribunu
//
//  Created by Halil İbrahim YÜCE on 29.06.2018.
//  Copyright © 2018 Halil İbrahim YÜCE. All rights reserved.
//

import UIKit

class VideolarCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var baslik: UILabel!
    @IBOutlet weak var yazarAvatar: UIImageView!
    @IBOutlet weak var haberGorseli: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.haberGorseli.image = nil
        self.haberGorseli.sd_cancelCurrentImageLoad()
    }

}
