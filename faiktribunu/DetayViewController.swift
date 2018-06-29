//
//  DetayViewController.swift
//  faiktribunu
//
//  Created by Halil İbrahim YÜCE on 29.06.2018.
//  Copyright © 2018 Halil İbrahim YÜCE. All rights reserved.
//

import UIKit
import WebKit
import PSHTMLView

class DetayViewController: UIViewController {
    
    @IBOutlet weak var detayGorsel: UIImageView!
    @IBOutlet weak var detayBaslik: UILabel!
    @IBOutlet weak var detayIcerik: WKWebView!
    
    let postUrl = URL(string:StaticVariables.baseUrl + "posts/12349")!
    
    var jsonDecoder = JSONDecoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let postData = try! Data(contentsOf: postUrl)
        let yazilar = try? jsonDecoder.decode(Yazilar.self, from: postData)
        detayBaslik.text = yazilar?.title.rendered.html2String
        detayIcerik.loadHTMLString("<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"><style>img{display: inline;height: auto;max-width:100%;}iframe {width:100%;}</style>" + (yazilar?.content.rendered)!, baseURL: nil)
        let resUrl = URL(string: StaticVariables.baseUrl + StaticVariables.resimUrl + "\((yazilar?.featured_media)!)")!
        let resimData = try! Data(contentsOf: resUrl)
        let resimler = try? jsonDecoder.decode(Resim.self, from: resimData)
        detayGorsel.downloadedFrom(link: (resimler?.guid.rendered)!)
        
    }

}
