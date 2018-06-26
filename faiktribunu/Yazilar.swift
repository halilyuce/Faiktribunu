//
//  Yazilar.swift
//  faiktribunu
//
//  Created by Halil İbrahim YÜCE on 1.06.2018.
//  Copyright © 2018 Halil İbrahim YÜCE. All rights reserved.
//

import Foundation

struct Yazilar:Codable{
    var title:Title
    var featured_media:Int
    var categories: [Int]
    
    struct Title:Codable {
        var rendered:String
    }
}


struct Resim:Codable {
    var guid:guid

    struct guid:Codable {
        var rendered:String
    }
}
