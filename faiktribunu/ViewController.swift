//
//  ViewController.swift
//  faiktribunu
//
//  Created by Halil İbrahim YÜCE on 28.05.2018.
//  Copyright © 2018 Halil İbrahim YÜCE. All rights reserved.
//

import UIKit
import ScrollableSegmentedControl
import AVKit

class ViewController: UIViewController {
   
    @IBOutlet weak var mViewMain: UIView!
    @IBOutlet weak var segmentedControl: ScrollableSegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        
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
        

        // Do any additional setup after loading the view.
        
        let bjktv = UIButton(type: .custom)
        bjktv.setImage(UIImage(named: "television"), for: UIControl.State.normal)
        bjktv.addTarget(self, action: #selector(self.bjkMethod), for: UIControl.Event.touchUpInside)
        let bjktvbtn = UIBarButtonItem(customView: bjktv)
        
        bjktv.widthAnchor.constraint(equalToConstant: 28.0).isActive = true
        bjktv.heightAnchor.constraint(equalToConstant: 28.0).isActive = true
    

        self.navigationItem.setRightBarButtonItems([bjktvbtn], animated: true)
        
        

        self.setupNavigationBar(image: UIImage(named: "navlogo")!)
        
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
    
    @objc func bjkMethod(){
        
        let mDetayViewController = DetayViewController(nibName: "DetayViewController", bundle: nil)
        self.navigationController?.pushViewController(mDetayViewController, animated: true)
        
        
        
        /*if let videoURL = URL.init(string: "https://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_1mb.mp4"){
           let avPlayerController = AVPlayerViewController()
            avPlayerController.player = AVPlayer.init(url: videoURL)
            self.present(avPlayerController, animated: true) {
                avPlayerController.player?.play()
            }
        }*/
        

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

    
}



