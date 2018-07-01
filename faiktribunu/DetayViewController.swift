//
//  DetayViewController.swift
//  faiktribunu
//
//  Created by Halil İbrahim YÜCE on 29.06.2018.
//  Copyright © 2018 Halil İbrahim YÜCE. All rights reserved.
//

import UIKit
import PSHTMLView
import Alamofire
import SwiftyJSON
import ObjectMapper
import WebKit

class DetayViewController: UIViewController {
    
    @IBOutlet weak var detayIcerik: WKWebView!
    
    var resimStr = String()
    var base = [Base]()
    var detayBase = [Title]()
    var resBase = [ResBase]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let detayUrl = StaticVariables.baseUrl + "posts/12371"
        Alamofire.request(detayUrl, method: .get, parameters: nil)
            .responseString { response in
                switch(response.result) {
                case .success(_):
                    if let ddata = response.data, let dutf8Text = String(data: ddata, encoding: .utf8) {
                        if let detay = Mapper<DetayList>().map(JSONString: dutf8Text){
                                    self.title = detay.title?.rendered
                                    self.resimStr = "\(detay.media!)"
                            
                            let resUrl = URL(string: StaticVariables.baseUrl + StaticVariables.resimUrl + self.resimStr)!
                            
                            Alamofire.request(resUrl, method: .get, parameters: nil)
                                .responseString { mresponse in
                                    
                                    switch(mresponse.result) {
                                    case .success(_):
                                        
                                        if let mdata = mresponse.data, let mutf8Text = String(data: mdata, encoding: .utf8) {
                                            
                                            if let guid = Mapper<ResList>().map(JSONString: mutf8Text){
                                                
                                                let resimUrl = guid.guid?.rendered
                                                
                                                self.detayIcerik.loadHTMLString("<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"><style>img{display: inline;height: auto;max-width:100%;}iframe {width:100%;}</style> <img src=\"\(guid.guid?.rendered)\"/> <br> <h3> \((detay.title?.rendered?.html2String)!) </h3>" + (detay.title?.rendered)!, baseURL: nil)
                                                
                                            }
                                            else{
                                                print("hatalı json")
                                                
                                            }
                                            
                                        }
                                        
                                    case .failure(_):
                                        print("Error message:\(String(describing: response.result.error))")
                                        break
                                    }
                                    
                            }
                            
                            
                            }
                        }
                        else{
                            print("hatalı json")
                        }
                case .failure(_):
                    print("Error message:\(String(describing: response.result.error))")
                    break
                }
        }
    }

}
