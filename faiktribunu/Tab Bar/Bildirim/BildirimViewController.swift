//
//  BildirimViewController.swift
//  faiktribunu
//
//  Created by Mac on 21.07.2018.
//  Copyright © 2018 Halil İbrahim YÜCE. All rights reserved.
//

import UIKit
import SafariServices

struct CellData {
    let baslik: String!
    let resim: UIImage!
}

class BildirimViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mTableView: UITableView!
    
var Bildirimler = [CellData]()
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavBarItems()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    let headerView = UIView()
        let headerText = UILabel()
        headerText.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 35)
        headerText.text = "BİLDİRİMLER"
        headerText.textColor = UIColor.white
        headerText.font = UIFont.boldSystemFont(ofSize: 18.0)
        headerText.textAlignment = .center
        headerView.addSubview(headerText)
        headerView.backgroundColor = UIColor.red
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 35)
        
        mTableView.tableHeaderView = headerView
        
        mTableView.register(UINib.init(nibName: "BildirimlerTableViewCell", bundle: nil), forCellReuseIdentifier: "BildirimlerTableViewCell")
        
        Bildirimler = [CellData(baslik: "Nirden tanıdım seni yavv", resim: UIImage(named: "faiklogo")),
        CellData(baslik: "Nirden tanıdım seni yavv 2", resim: UIImage(named: "faiklogo")),
        CellData(baslik: "Nirden tanıdım seni yavv 3", resim: UIImage(named: "faiklogo")),
        CellData(baslik: "Nirden tanıdım seni yavv 4", resim: UIImage(named: "faiklogo")),
        CellData(baslik: "Nirden tanıdım seni yavv 5", resim: UIImage(named: "faiklogo"))]

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        mAppDelegate.mNavigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Bildirimler.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BildirimlerTableViewCell", for: indexPath) as! BildirimlerTableViewCell
        cell.baslik.text = Bildirimler[indexPath.row].baslik
        cell.resim.image = Bildirimler[indexPath.row].resim
        
        cell.resim.layer.cornerRadius = cell.resim.frame.height/2
        cell.resim.clipsToBounds = true
        
        return cell
        
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
