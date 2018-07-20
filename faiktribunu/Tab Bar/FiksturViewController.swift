//
//  FiksturViewController.swift
//  faiktribunu
//
//  Created by Mac on 19.07.2018.
//  Copyright © 2018 Halil İbrahim YÜCE. All rights reserved.
//

import UIKit
import AVKit
import WebKit

class FiksturViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavBarItems()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        mAppDelegate.mNavigationController?.setNavigationBarHidden(true, animated: false)

        self.webView.loadHTMLString("<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"><iframe src=\"http://haberciniz.biz/service/sport/league_standing_table.php?color=1&select=TUR1,TUR2,SPA1,ENG1,GER1\" width=\"100%\" height=\"550px\" frameborder=\"0\" scrolling=\"AUTO\"></iframe>", baseURL: nil)
    }


    func setNavBarItems(){
        
        let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: 144, height: 32))
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 144, height: 32))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "faiknav")
        imageView.image = image
        logoContainer.addSubview(imageView)
        self.navigationItem.titleView = logoContainer
        
        
        let bjktv = UIButton(type: .custom)
        bjktv.setImage(UIImage(named: "television"), for: UIControl.State.normal)
        bjktv.addTarget(self, action: #selector(self.bjkMethod), for: UIControl.Event.touchUpInside)
        let bjktvbtn = UIBarButtonItem(customView: bjktv)
        
        bjktv.widthAnchor.constraint(equalToConstant: 28.0).isActive = true
        bjktv.heightAnchor.constraint(equalToConstant: 28.0).isActive = true
        
        
        self.navigationItem.setRightBarButtonItems([bjktvbtn], animated: true)
        
        let menu = UIButton(type: .custom)
        menu.setImage(UIImage(named: "menu"), for: UIControl.State.normal)
        menu.addTarget(self, action: #selector(self.menuMethod), for: UIControl.Event.touchUpInside)
        let menubtn = UIBarButtonItem(customView: menu)
        
        menu.widthAnchor.constraint(equalToConstant: 24.0).isActive = true
        menu.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
        
        
        self.navigationItem.setLeftBarButtonItems([menubtn], animated: true)
        
    }
    
    @objc func menuMethod(){
        
        if let videoURL = URL.init(string: "https://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_1mb.mp4"){
            let avPlayerController = AVPlayerViewController()
            avPlayerController.player = AVPlayer.init(url: videoURL)
            self.present(avPlayerController, animated: true) {
                avPlayerController.player?.play()
            }
        }
        
    }
    
    @objc func bjkMethod(){
        
        let mBJKTVViewController = BJKTVViewController(nibName: "BJKTVViewController", bundle: nil)
        self.navigationController?.pushViewController(mBJKTVViewController, animated: true)
        
        /*if let videoURL = URL.init(string: "https://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_1mb.mp4"){
         let avPlayerController = AVPlayerViewController()
         avPlayerController.player = AVPlayer.init(url: videoURL)
         self.present(avPlayerController, animated: true) {
         avPlayerController.player?.play()
         }
         }*/
        
    }

}
