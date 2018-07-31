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
import SVPullToRefresh

class BildirimViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mTableView: UITableView!
    
    var baslikStr = [String]()
    var updatedBaslikStr = [String]()
    var resimStr = [String]()
    var updatedResimStr = [String]()
    var datepost = [String]()
    var updatedDatepost = [String]()
    var yazinumara = [String]()
    var updatedYazinumara = [String]()
    var bodyStr = [String]()
    var updatedBodyStr = [String]()
    var videoLink = [String]()
    var updatedVideoLink = [String]()
    var format = [String]()
    var updatedFormat = [String]()
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavBarItems()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        mAppDelegate.mNavigationController?.setNavigationBarHidden(true, animated: false)
        

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
        
        
        self.mTableView.addPullToRefresh {
            
            self.mTableView.pullToRefreshView.startAnimating()
            
            self.baslikStr.removeAll(keepingCapacity: false)
            
            self.resimStr.removeAll(keepingCapacity: false)
            
            self.bodyStr.removeAll(keepingCapacity: false)
            
            self.datepost.removeAll(keepingCapacity: false)
            
            self.yazinumara.removeAll(keepingCapacity: false)
            
            self.format.removeAll(keepingCapacity: false)
            
            self.videoLink.removeAll(keepingCapacity: false)

            self.loadList()
            
        }
    
        
        self.mTableView.pullToRefreshView.setTitle("Yenilemek için Aşağı Kaydır", forState: 0)
        self.mTableView.pullToRefreshView.setTitle("Yenilemekten Vazgeç...", forState: 1)
        self.mTableView.pullToRefreshView.setTitle("Yükleniyor...", forState: 2)
        
        self.mTableView.delegate = self
        
        self.loadList()

    }
    
    func loadList(){
        
        let context = mAppDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Bildirimler")
        let sectionSortDescriptor = NSSortDescriptor(key: "update", ascending: false)
        let sortDescriptors = [sectionSortDescriptor]
        request.sortDescriptors = sortDescriptors
        
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                if let title = data.value(forKey: "postTitle") as? String {
                    self.baslikStr.append(title)
                }
                if let resimUrl = data.value(forKey: "postResimUrl") as? String {
                    self.resimStr.append(resimUrl)
                }
                if let selectedPostID = data.value(forKey: "postID") as? String {
                    self.yazinumara.append(selectedPostID)
                }
                if let bodyPost = data.value(forKey: "postBody") as? String {
                    self.bodyStr.append(bodyPost)
                }
                if let videoUrl = data.value(forKey: "postVideoUrl") as? String {
                    self.videoLink.append(videoUrl)
                }
                if let postFormat = data.value(forKey: "postFormat") as? String {
                    self.format.append(postFormat)
                }
                if let postDate = data.value(forKey: "update") as? String {
                    self.datepost.append(postDate)
                }
                
            }
            
            print("İlk \(baslikStr)")
            
            if baslikStr.count > 2{
                
                    baslikStr.removeLast()
                    resimStr.removeLast()
                    datepost.removeLast()
                    bodyStr.removeLast()
                    yazinumara.removeLast()
                    format.removeLast()
                    videoLink.removeLast()
           
                for yazi in yazinumara{
                    updatedYazinumara.append(yazi)
                }
                
                for body in bodyStr{
                    updatedBodyStr.append(body)
                }
     
                for baslik in baslikStr{
                    updatedBaslikStr.append(baslik)
                }
                
                for form in format{
                    updatedFormat.append(form)
                }
                
                for video in videoLink{
                    updatedVideoLink.append(video)
                }
                
                for resim in resimStr{
                    updatedResimStr.append(resim)
                }
                
                for date in datepost{
                    updatedDatepost.append(date)
                }
                
                print("Before Delete \(baslikStr)")
                print("Updated \(updatedBaslikStr)")
                
                deleteAllRecords()
                
                updateAllRecords()
                
                 }
            
            print("Last \(updatedBaslikStr)")
            
            self.mTableView.reloadData()
            self.mTableView.pullToRefreshView.stopAnimating()
            
        } catch {
            
            print("Failed")
        }
  
        }

    func deleteAllRecords() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Bildirimler")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
    func updateAllRecords() {
        
        let updated = mAppDelegate.persistentContainer.viewContext
        let yeniBildirim = NSEntityDescription.insertNewObject(forEntityName: "Bildirimler", into: updated)
        
        for updatedYazi in updatedYazinumara{
            yeniBildirim.setValue(updatedYazi, forKey: "postID")
        }
        
        for updatedBody in updatedBodyStr{
            yeniBildirim.setValue(updatedBody, forKey: "postBody")
        }
        
        for updatedBaslik in updatedBaslikStr{
            yeniBildirim.setValue(updatedBaslik, forKey: "postTitle")
        }
        
        for updatedForm in updatedFormat{
            yeniBildirim.setValue(updatedForm, forKey: "postFormat")
        }
        
        for updatedVideo in updatedVideoLink{
            yeniBildirim.setValue(updatedVideo, forKey: "postVideoUrl")
        }
        
        for updatedResim in updatedResimStr{
            yeniBildirim.setValue(updatedResim, forKey: "postResimUrl")
        }
        
        for updatedDate in updatedDatepost{
            yeniBildirim.setValue(updatedDate, forKey: "update")
        }
        
        do {
            try updated.save()
            print("güncellendi")
        } catch {
            print("Failed saving")
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return baslikStr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BildirimlerTableViewCell", for: indexPath) as! BildirimlerTableViewCell
        
        if indexPath.row < baslikStr.count{
        cell.baslik.text = baslikStr[indexPath.row].html2String
        cell.resim.sd_setImage(with: URL(string: resimStr[indexPath.row]), placeholderImage:  UIImage(named: "faiklogo"))
        
        cell.resim.layer.cornerRadius = cell.resim.frame.height/2
        cell.resim.clipsToBounds = true
        }
        
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
        if Int(selectedItem) != nil{
        self.navigationController?.pushViewController(mDetayViewController, animated: true)
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
