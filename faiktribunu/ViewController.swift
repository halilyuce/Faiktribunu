//
//  ViewController.swift
//  faiktribunu
//
//  Created by Mac on 19.07.2018.
//  Copyright © 2018 Halil İbrahim YÜCE. All rights reserved.
//

import UIKit
import ScrollableSegmentedControl
import AVKit
import SafariServices

class ViewController: UIViewController {
    
    @IBOutlet weak var mViewMain: UIView!
    @IBOutlet weak var segmentedControl: ScrollableSegmentedControl!
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavBarItems()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        mAppDelegate.mNavigationController?.setNavigationBarHidden(true, animated: false)
        
        segmentedControl.segmentStyle = .textOnly
        segmentedControl.insertSegment(withTitle: "YAZILAR", at: 0)
        segmentedControl.insertSegment(withTitle: "GÜNDEM", at: 1)
        segmentedControl.insertSegment(withTitle: "VİDEOLAR", at: 2)
        segmentedControl.insertSegment(withTitle: "TARİH", at: 3)
        segmentedControl.insertSegment(withTitle: "SÖYLEYİŞİ", at: 4)
        segmentedControl.insertSegment(withTitle: "KONUKLAR", at: 5)
        
        segmentedControl.underlineSelected = true
        
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: #selector(ViewController.segmentSelected(sender:)), for: UIControl.Event.valueChanged)
        
        
        if let mYazilarViewController = YazilarViewController(nibName:"YazilarViewController", bundle: nil) as? YazilarViewController {
            addChild(mYazilarViewController)
            mYazilarViewController.view.frame = CGRect.init(x: 0, y: 0, width: StaticVariables.screenWidth, height: self.mViewMain.bounds.height)
            if let aView = mYazilarViewController.view {
                aView.tag = 101
                self.mViewMain.addSubview(aView)
            }
            mYazilarViewController.didMove(toParent: self)
        }
        
    }
    
    
    @objc func segmentSelected(sender:ScrollableSegmentedControl) {
        print("Segment at index \(sender.selectedSegmentIndex)  selected")
        
        if let subview = self.mViewMain.viewWithTag(101){
            subview.removeFromSuperview()
        }
        switch sender.selectedSegmentIndex {
        case 0:
            if let mYazilarViewController = YazilarViewController(nibName:"YazilarViewController", bundle: nil) as? YazilarViewController {
                addChild(mYazilarViewController)
                mYazilarViewController.view.frame = CGRect.init(x: 0, y: 0, width: StaticVariables.screenWidth, height: self.mViewMain.bounds.height)
                if let aView = mYazilarViewController.view {
                    aView.tag = 101
                    self.mViewMain.addSubview(aView)
                }
                mYazilarViewController.didMove(toParent: self)
            }
        case 1:
            if let gGundemViewController = GundemViewController(nibName:"GundemViewController", bundle: nil) as? GundemViewController {
                addChild(gGundemViewController)
                gGundemViewController.view.frame = CGRect.init(x: 0, y: 0, width: StaticVariables.screenWidth, height: self.mViewMain.bounds.height)
                if let aView = gGundemViewController.view {
                    aView.tag = 101
                    self.mViewMain.addSubview(aView)
                }
                gGundemViewController.didMove(toParent: self)
            }
        case 2:
            if let vVideolarViewController = VideolarViewController(nibName:"VideolarViewController", bundle: nil) as? VideolarViewController {
                addChild(vVideolarViewController)
                vVideolarViewController.view.frame = CGRect.init(x: 0, y: 0, width: StaticVariables.screenWidth, height: self.mViewMain.bounds.height)
                if let aView = vVideolarViewController.view {
                    aView.tag = 101
                    self.mViewMain.addSubview(aView)
                }
                vVideolarViewController.didMove(toParent: self)
            }
        case 3:
            if let tTarihViewController = TarihViewController(nibName:"TarihViewController", bundle: nil) as? TarihViewController {
                addChild(tTarihViewController)
                tTarihViewController.view.frame = CGRect.init(x: 0, y: 0, width: StaticVariables.screenWidth, height: self.mViewMain.bounds.height)
                if let aView = tTarihViewController.view {
                    aView.tag = 101
                    self.mViewMain.addSubview(aView)
                }
                tTarihViewController.didMove(toParent: self)
            }
        case 4:
            if let sSoyleyisiViewController = SoyleyisiViewController(nibName:"SoyleyisiViewController", bundle: nil) as? SoyleyisiViewController {
                addChild(sSoyleyisiViewController)
                sSoyleyisiViewController.view.frame = CGRect.init(x: 0, y: 0, width: StaticVariables.screenWidth, height: self.mViewMain.bounds.height)
                if let aView = sSoyleyisiViewController.view {
                    aView.tag = 101
                    self.mViewMain.addSubview(aView)
                }
                sSoyleyisiViewController.didMove(toParent: self)
            }
        case 5:
            if let kKonuklarViewController = KonuklarViewController(nibName:"KonuklarViewController", bundle: nil) as? KonuklarViewController {
                addChild(kKonuklarViewController)
                kKonuklarViewController.view.frame = CGRect.init(x: 0, y: 0, width: StaticVariables.screenWidth, height: self.mViewMain.bounds.height)
                if let aView = kKonuklarViewController.view {
                    aView.tag = 101
                    self.mViewMain.addSubview(aView)
                }
                kKonuklarViewController.didMove(toParent: self)
            }
            
        default:
            if let mYazilarViewController = YazilarViewController(nibName:"YazilarViewController", bundle: nil) as? YazilarViewController {
                addChild(mYazilarViewController)
                mYazilarViewController.view.frame = CGRect.init(x: 0, y: 0, width: StaticVariables.screenWidth, height: self.mViewMain.bounds.height)
                if let aView = mYazilarViewController.view {
                    aView.tag = 101
                    self.mViewMain.addSubview(aView)
                }
                mYazilarViewController.didMove(toParent: self)
            }
            
        }
        
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
        menu.setImage(UIImage(named: "bjk"), for: UIControl.State.normal)
        menu.addTarget(self, action: #selector(self.menuMethod), for: UIControl.Event.touchUpInside)
        let menubtn = UIBarButtonItem(customView: menu)
        
        menu.widthAnchor.constraint(equalToConstant: 26.0).isActive = true
        menu.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        
        
        self.navigationItem.setLeftBarButtonItems([menubtn], animated: true)
        
    }
    
    @objc func menuMethod(){
        
        let bjkurl = URL.init(string: "http://www.bjk.com.tr")
        let svc = SFSafariViewController(url: bjkurl!)
        present(svc, animated: true, completion: nil)
        
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
