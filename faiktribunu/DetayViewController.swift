//
//  DetayViewController.swift
//  faiktribunu
//
//  Created by Halil İbrahim YÜCE on 29.06.2018.
//  Copyright © 2018 Halil İbrahim YÜCE. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ObjectMapper
import WebKit
import AVKit

class DetayViewController: UIViewController {
    
    @IBOutlet weak var detayIcerik: WKWebView!
    
    var resimStr = String()
    var resimShare = String()
    var baslik = String()
    var base = [Base]()
    var detayBase = [Title]()
    var resBase = [ResBase]()
    var yaziNumara = String()
    var yaziFormat = String()
    var videoLink = String()
    
    var showBackButton = false
    
    let imagePicker = UIImagePickerController()
    let messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let share = UIButton(type: .custom)
        share.setImage(UIImage(named: "share"), for: UIControl.State.normal)
        share.addTarget(self, action: #selector(self.shareMethod), for: UIControl.Event.touchUpInside)
        let sharebtn = UIBarButtonItem(customView: share)
        
        share.widthAnchor.constraint(equalToConstant: 28.0).isActive = true
        share.heightAnchor.constraint(equalToConstant: 28.0).isActive = true
        
        
        self.navigationItem.setRightBarButtonItems([sharebtn], animated: true)
        
        if showBackButton{
            self.setBackButton()
        }
        
        self.activityIndicator("Yükleniyor")
        
        let detayUrl = StaticVariables.baseUrl + "posts/\(yaziNumara)"
        Alamofire.request(detayUrl, method: .get, parameters: nil)
            .responseString { response in
                switch(response.result) {
                case .success(_):
                    if let ddata = response.data, let dutf8Text = String(data: ddata, encoding: .utf8) {
                        if let detay = Mapper<DetayList>().map(JSONString: dutf8Text){
                                    self.title = detay.title?.rendered?.html2String
                            self.baslik.append((detay.title?.rendered)!)
                                    self.resimStr = "\(detay.media!)"
                            
                            let resUrl = URL(string: StaticVariables.baseUrl + StaticVariables.resimUrl + self.resimStr)!
                            
                            Alamofire.request(resUrl, method: .get, parameters: nil)
                                .responseString { mresponse in
                                    
                                    switch(mresponse.result) {
                                    case .success(_):
                                        
                                        if let mdata = mresponse.data, let mutf8Text = String(data: mdata, encoding: .utf8) {
                                            
                                            if let guid = Mapper<ResList>().map(JSONString: mutf8Text){
                                                
                                                if self.yaziFormat == "video" {
                                                    
                                                    self.detayIcerik.loadHTMLString("<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"> <style>body{font-size:18px} .wp-caption{max-width:100%;background:#eee;padding: 5px;} .wp-caption img{max-width:100%;height:auto;width: 100%;} .entry-content img {max-width:100%;height:auto;} img{display:inline; height:auto; max-width:100%;} embed, iframe, object {max-width:100%;height:225px;}</style> <iframe width=\"100%\" height=\"225\" src=\"https://www.youtube.com/embed/\(self.videoLink)\" frameborder=\"0\" allow=\"autoplay; encrypted-media\" allowfullscreen></iframe> <br> <h3> \((detay.title?.rendered?.html2String)!) </h3>" + (detay.content?.rendered)!, baseURL: nil)
                                                    
                                                    
                                                    
                                                } else{
                                                   
                                                    self.detayIcerik.loadHTMLString("<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"> <style>body{font-size:18px} .wp-caption{max-width:100%;background:#eee;padding: 5px;} .wp-caption img{max-width:100%;height:auto;width: 100%;} .entry-content img {max-width:100%;height:auto;} img{display:inline; height:auto; max-width:100%;} embed, iframe, object {max-width:100%;height:225px;}</style> <img src=\"\((guid.guid?.rendered)!)\"> <br> <h3> \((detay.title?.rendered?.html2String)!) </h3>" + (detay.content?.rendered)!, baseURL: nil)
                                                    
                                                }
                                                
                                                self.effectView.removeFromSuperview()
                                                
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
    
    
    

    @objc func shareMethod(){

        let string: String = baslik
        let URL: String = "http://faiktribunu.com/?p=\(yaziNumara)"
        
        let activityViewController = UIActivityViewController(activityItems: [string, URL], applicationActivities: nil)
        navigationController?.present(activityViewController, animated: true) {
        }
        
        
    }
    
    
    func activityIndicator(_ title: String) {
        
        strLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()
        
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 160, height: 46))
        strLabel.text = title
        strLabel.font = .systemFont(ofSize: 14, weight: .medium)
        strLabel.textColor = UIColor(white: 0.9, alpha: 0.7)
        
        effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2 , y: view.frame.midY - strLabel.frame.height * 2 , width: 160, height: 46)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        
        activityIndicator = UIActivityIndicatorView(style: .white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator.startAnimating()
        
        effectView.contentView.addSubview(activityIndicator)
        effectView.contentView.addSubview(strLabel)
        view.addSubview(effectView)
    }
    
    func setBackButton(){
        
        let buttonBack = UIButton()
        buttonBack.setTitle("X", for: .normal)
        buttonBack.frame = CGRect.init(x: 0, y: 0, width: 48, height: 48)
        buttonBack.tintColor = UIColor.white
        buttonBack.setTitleColor(UIColor.white, for: .normal)
        
        buttonBack.widthAnchor.constraint(equalToConstant: 48.0).isActive = true
        buttonBack.heightAnchor.constraint(equalToConstant: 48.0).isActive = true
        
        buttonBack.addTarget(self, action: #selector(self.backTouch), for: UIControl.Event.touchUpInside)
        
        let barButton = UIBarButtonItem.init(customView: buttonBack)
        
        self.navigationItem.leftBarButtonItem = barButton
        
    }
    
    @objc func backTouch(){
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

    

}
