//
//  StaticVariables.swift
//  faiktribunu
//
//  Created by Halil İbrahim YÜCE on 5.06.2018.
//  Copyright © 2018 Halil İbrahim YÜCE. All rights reserved.
//

import Foundation
import UIKit

class StaticVariables: NSObject{
    
    
    public static let screenSize = UIScreen.main.bounds
    public static let screenWidth:CGFloat = screenSize.width
    public static let screenHeight:CGFloat = screenSize.height
    
    public static let baseUrl:String = "https://www.faiktribunu.com/index.php/wp-json/wp/v2/"
    public static let homeUrl:String = "https://www.faiktribunu.com/"
    public static let catAvatar:String = "wp-content/themes/faiktribunu/assets/images/"
    public static let postUrl:String = "posts/"
    public static let resimUrl:String = "media/"
    public static let userUrl:String = "users/"
    public static let kategoriUrl:String = "categories/"
    
}
