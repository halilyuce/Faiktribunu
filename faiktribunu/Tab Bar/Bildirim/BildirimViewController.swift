//
//  BildirimViewController.swift
//  faiktribunu
//
//  Created by Mac on 21.07.2018.
//  Copyright © 2018 Halil İbrahim YÜCE. All rights reserved.
//

import UIKit
import SDWebImage
import SafariServices
import CoreData

struct CellData {
    let baslik: String!
    let resim: String!
}

class BildirimViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mTableView: UITableView!
    
var Bildirimler = [CellData]()
    var baslikStr = [String]()
    var resimStr = [String]()
    var yazinumara = [String]()
    var bodyStr = [String]()
    var videoLink = [String]()
    var format = [String]()
    
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
        headerText.font = UIFont.boldSystemFont(ofSize: 16.0)
        headerText.textAlignment = .center
        headerView.addSubview(headerText)
        headerView.backgroundColor = UIColor.red
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 35)
        
        mTableView.tableHeaderView = headerView
        
        mTableView.register(UINib.init(nibName: "BildirimlerTableViewCell", bundle: nil), forCellReuseIdentifier: "BildirimlerTableViewCell")
        
        
        let context = mAppDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Bildirimler")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                if let title = data.value(forKey: "postTitle") as? String {
                    self.baslikStr.append(title)
                    print(baslikStr)
                }
                if let resimUrl = data.value(forKey: "postResimUrl") as? String {
                    self.resimStr.append(resimUrl)
                    print(resimUrl)
                }
                if let selectedPostID = data.value(forKey: "postID") as? String {
                    self.yazinumara.append(selectedPostID)
                    print(selectedPostID)
                }
                if let videoUrl = data.value(forKey: "postVideoUrl") as? String {
                    self.videoLink.append(videoUrl)
                    print(videoUrl)
                }
                if let postFormat = data.value(forKey: "postFormat") as? String {
                    self.format.append(postFormat)
                    print(postFormat)
                }
            }
            
        } catch {
            
            print("Failed")
        }
        
        
        Bildirimler = [CellData(baslik: "Faiktribünü Canlı Yayın Sohbeti; \n Bu Akşam Saat 21:00`da", resim: "https://azdhs.gov/assets/images/on-air-placeholder.jpg"),
                       CellData(baslik: "Cem Göncü yazdı; \n \"Neden Olmadı ? (2.Bölüm-Saha İçi)\"", resim: "https://www.faiktribunu.com/wp-content/uploads/2016/08/CeecHenu-1.jpg"),
                       CellData(baslik: "Kaybettiklerimiz; \n Hakkı Yeten (1910-1989) – Baba Hakkı", resim: "https://www.faiktribunu.com/wp-content/uploads/2016/08/rHdUrY5p-1.jpg"),
        CellData(baslik: "Beşiktaş 3-1 Krasnodar", resim: "http://cdn.shopify.com/s/files/1/1325/1409/products/48-Soccer-Ball-Solo_Single_Front_grande_9a65142b-ea92-4060-96ed-eafe3737feb7_grande.png?v=1527558493"),
        CellData(baslik: "Hata Bildirimleri ve Öneriler İçin Twitter`dan @faiktribunu Hesabına DM Atabilirsiniz :) ", resim: "https://www.faiktribunu.com/wp-content/uploads/ultimatemember/37/profile_photo-190.jpg?1532200562"),
        CellData(baslik: "FaikTribünü Mobil Uygulaması İlk Versiyonu İle Yayında !", resim: "https://www.faiktribunu.com/wp-content/uploads/ultimatemember/37/profile_photo-190.jpg?1532200562")]

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        mAppDelegate.mNavigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return baslikStr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BildirimlerTableViewCell", for: indexPath) as! BildirimlerTableViewCell
        cell.baslik.text = baslikStr[indexPath.row].html2String
        cell.resim.sd_setImage(with: URL(string: resimStr[indexPath.row]), placeholderImage:  UIImage(named: "faiklogo"))
        
        cell.resim.layer.cornerRadius = cell.resim.frame.height/2
        cell.resim.clipsToBounds = true
        
        return cell
        
    }
    
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = yazinumara[indexPath.row]
        let videoItem = videoLink[indexPath.row]
        let formatItem = format[indexPath.row]
        
        let mDetayViewController = DetayViewController(nibName: "DetayViewController", bundle: nil)
        mDetayViewController.yaziNumara = selectedItem
        mDetayViewController.yaziFormat = formatItem
        mDetayViewController.videoLink = videoItem
        self.navigationController?.pushViewController(mDetayViewController, animated: true)
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
