//
//  icerik.swift
//  faiktribunu
//
//  Created by Halil İbrahim YÜCE on 29.05.2018.
//  Copyright © 2018 Halil İbrahim YÜCE. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import PSHTMLView

struct Post: Decodable {
    let title: title
    let content: content
}

struct title: Decodable {
    let rendered: String
}

struct content: Decodable {
    let rendered: String
}

var gelenTitle: String?
var gelenContent: String?
var styledContent: String?
var style = "<style>img {width:100%;height:auto;} embed, iframe, object {max-width:100%;}</style>"

class icerik: UIViewController {
    @IBOutlet weak var webView: PSHTMLView!
    @IBOutlet weak var baslik: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let url = "http://yucetasarim.com/demo/supreme/wp-json/wp/v2/posts"
        let urlObj = URL(string: url)
        
        URLSession.shared.dataTask(with: urlObj!) {(data, response, error) in
            
            do {
                var posts = try JSONDecoder().decode([Post].self,
                                                     from: data!)
                
                for post in posts {
                    print(post.title.rendered)
                    gelenTitle = post.title.rendered
                    gelenContent = post.content.rendered
                    styledContent = style + gelenContent!
                    break
                }
                
            } catch {
                print("Bir hata oluştu")
            }
            
            OperationQueue.main.addOperation {
                self.baslik.text = gelenTitle?.html2String
                self.webView.webView.scrollView.isScrollEnabled = true
                
                self.webView.html = styledContent
            }
            
            }.resume()
        
        
    }
    
    
}

