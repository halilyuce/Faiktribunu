//
//  BJKTVViewController.swift
//  faiktribunu
//
//  Created by Halil İbrahim YÜCE on 27.06.2018.
//  Copyright © 2018 Halil İbrahim YÜCE. All rights reserved.
//

import UIKit
import NightNight

class BJKTVViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var myWebView: UIWebView!
    @IBOutlet weak var yazi: UILabel!
    
    let imagePicker = UIImagePickerController()
    let messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.mixedBackgroundColor = MixedColor(normal: UIColor.groupTableViewBackground, night: UIColor(hexString: "#282828"))
        yazi.mixedTextColor = MixedColor(normal: UIColor.black, night: UIColor.white)
        

        EmbedVideo(videoId: "x31omum")
        myWebView.delegate = self
        
       
        
        
    self.title = "BJK TV"
 
    }
    

    func webViewDidStartLoad(_ webView: UIWebView){
       self.activityIndicator("Yükleniyor")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView){
        self.effectView.removeFromSuperview()
    }
    
    func EmbedVideo(videoId:String) {
        let videoLink = URL(string: "https://www.dailymotion.com/embed/video/\(videoId)")
        myWebView.loadRequest(URLRequest(url: videoLink!))
    }

    

    func activityIndicator(_ title: String) {
        
        strLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()
        
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 160, height: 46))
        strLabel.text = title
        strLabel.font = .systemFont(ofSize: 14, weight: .medium)
        strLabel.textColor = UIColor(white: 0.9, alpha: 0.7)
        
        effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2 , y: view.frame.midY - strLabel.frame.height * 4 , width: 160, height: 46)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        
        activityIndicator = UIActivityIndicatorView(style: .white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator.startAnimating()
        
        effectView.contentView.addSubview(activityIndicator)
        effectView.contentView.addSubview(strLabel)
        view.addSubview(effectView)
    }
    

}
