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
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class ViewController: UIViewController {
    
    @IBOutlet weak var mViewMain: UIView!
    @IBOutlet weak var segmentedControl: ScrollableSegmentedControl!
    var categoriesList = [String]()
    var categoriesID = [Int]()
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavBarItems()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        mAppDelegate.mNavigationController?.setNavigationBarHidden(true, animated: false)
        
        
        self.loadList{ () -> () in
            
                self.segmentedControl.segmentStyle = .textOnly
                var index = 1
                self.segmentedControl.insertSegment(withTitle: "TÜM YAZILAR", at: 0)
                for category in self.categoriesList{
                    self.segmentedControl.insertSegment(withTitle: category.uppercased(), at: index)
                    index += 1
                }
                
                self.segmentedControl.underlineSelected = true
                
                self.segmentedControl.selectedSegmentIndex = 0
                
                self.segmentedControl.addTarget(self, action: #selector(ViewController.segmentSelected(sender:)), for: UIControl.Event.valueChanged)
            
        }
        
        
        
        
        if let mYazilarViewController = YazilarViewController(nibName:"YazilarViewController", bundle: nil) as? YazilarViewController {
            addChild(mYazilarViewController)
            mYazilarViewController.view.frame = CGRect.init(x: 0, y: 0, width: self.mViewMain.bounds.width, height: self.mViewMain.bounds.height)
            if let aView = mYazilarViewController.view {
                aView.tag = 101
                self.mViewMain.addSubview(aView)
            }
            mYazilarViewController.didMove(toParent: self)
        }
        
    }
    
    
    @objc func segmentSelected(sender:ScrollableSegmentedControl) {
        
        if sender.selectedSegmentIndex != 0{
            page = categoriesID[sender.selectedSegmentIndex - 1]
        }
        
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
        default:
            if let gGundemViewController = GundemViewController(nibName:"GundemViewController", bundle: nil) as? GundemViewController {
                addChild(gGundemViewController)
                gGundemViewController.view.frame = CGRect.init(x: 0, y: 0, width: StaticVariables.screenWidth, height: self.mViewMain.bounds.height)
                if let aView = gGundemViewController.view {
                    aView.tag = 101
                    self.mViewMain.addSubview(aView)
                }
                gGundemViewController.didMove(toParent: self)
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
    
    func loadList(handleComplete:@escaping (()->())){
        
        let url = "https://www.faiktribunu.com/wp-json/wp/v2/categories"
        
        AF.request(url, method: .get, parameters: nil)
            .responseString { response in
                
                switch(response.result) {
                case .success(_):
                    
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            
                            let jsonString: String = "{\"lst\":" + utf8Text + "}"
                            
                            if let item = Mapper<cList>().map(JSONString: jsonString){
                                
                                if let item = item.lst{
                                    
                                    for it in item{
                                        self.categoriesList.append(it.name!)
                                        self.categoriesID.append(it.id!)
                                    }
                                    
                                }
                            
                        }
                        else{
                            print("hatalı json")
                            
                        }
                        
                    }
                    
                case .failure(_):
                    print("Error message:\(String(describing: response.result.error))")
                    break
                }
                
                handleComplete()
        }
        
        
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
