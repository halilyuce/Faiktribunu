//
//  GizlilikViewController.swift
//  faiktribunu
//
//  Created by Mac on 1.08.2018.
//  Copyright © 2018 Halil İbrahim YÜCE. All rights reserved.
//

import UIKit

class GizlilikViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var gizliweb: UIWebView!
    
    let imagePicker = UIImagePickerController()
    let messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Gizlilik Sözleşmesi"
        
        let Link = URL(string: "https://www.faiktribunu.com/gizlilik.html")
        self.gizliweb.loadRequest(URLRequest(url: Link!))

        gizliweb.delegate = self

}
    
    func webViewDidStartLoad(_ webView: UIWebView){
        self.activityIndicator("Yükleniyor")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView){
        self.effectView.removeFromSuperview()
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
    
}
