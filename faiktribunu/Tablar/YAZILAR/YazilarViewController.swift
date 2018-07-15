//
//  YazilarViewController.swift
//  faiktribunu
//
//  Created by Halil İbrahim YÜCE on 28.06.2018.
//  Copyright © 2018 Halil İbrahim YÜCE. All rights reserved.
//

import UIKit
import PSHTMLView
import Alamofire
import SwiftyJSON
import ObjectMapper
import SVPullToRefresh
import SDWebImage

class YazilarViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var mCollectionView: UICollectionView!
    
    var basliklar = [String]()
    var resimStr = String()
    var yazinumara = [String]()
    var resimLink = [String]()
    var videoLink = [String]()
    var catResim = [String]()
    var format = [String]()
    var base = [Base]()
    var resBase = [ResBase]()
    
    var mPageIndex = 1
    let imagePicker = UIImagePickerController()
    let messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mCollectionView.register(YazilarCollectionViewCell.self, forCellWithReuseIdentifier: "YazilarCollectionViewCell")
        mCollectionView.register(UINib.init(nibName: "YazilarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "YazilarCollectionViewCell")

        self.mCollectionView.addPullToRefresh {
            
        }
        
        self.mCollectionView.pullToRefreshView.setTitle("Yenilemek için Aşağı Kaydır", forState: 0)
        self.mCollectionView.pullToRefreshView.setTitle("Yenilemekten Vazgeç...", forState: 1)
        self.mCollectionView.pullToRefreshView.setTitle("Yükleniyor...", forState: 2)
  
        self.mCollectionView.delegate = self
        
        self.activityIndicator("Yükleniyor")
        
        let url = "https://www.faiktribunu.com/index.php/wp-json/wp/v2/posts/"
        
        Alamofire.request(url, method: .get, parameters: nil)
            .responseString { response in
                
                switch(response.result) {
                case .success(_):
                    
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        
                        let jsonString: String = "{\"lst\":" + utf8Text + "}"
                        
                        if let item = Mapper<List>().map(JSONString: jsonString){
                            
                            if let item = item.lst{
                                
                                self.base = item

                                for title in item{
                                   
                                    self.basliklar.append((title.title?.rendered)!)
                                    
                                    self.yazinumara.append("\(title.id!)")
                                    
                                    self.format.append((title.format)!)
                                    
                                    self.videoLink.append(title.video_url!)
                                    
                                    self.resimStr = "\(title.media!)"
                                    
                                    self.catResim.append(StaticVariables.homeUrl + StaticVariables.catAvatar + "\(title.categories![0])" + ".png")
                                    
                                    let resUrl = URL(string: StaticVariables.baseUrl + StaticVariables.resimUrl + self.resimStr)!
                      
                                    
                                    Alamofire.request(resUrl, method: .get, parameters: nil)
                                        .responseString { mresponse in
                                            
                                            switch(mresponse.result) {
                                            case .success(_):
                                    
                                                if let mdata = mresponse.data, let mutf8Text = String(data: mdata, encoding: .utf8) {
                                                    
                                                    //let mjsonString: String = "{\"rst\":" + mutf8Text + "}"
                                                    
                                                    if let guid = Mapper<ResList>().map(JSONString: mutf8Text){
                                                        
                                                        let resimUrl = guid.guid?.rendered
                                                        
                                                        self.resimLink.append(resimUrl!)
                                                        
                                                        if item.last?.id == title.id{
                                                            
                                                            self.mCollectionView.reloadData()
                                                            self.effectView.removeFromSuperview()
                                                            
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
                                            
                                            
                                    }
                                    
                                    
                                    
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

        
        }
        
        
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: UIScreen.main.bounds.width - 20, height: 250)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return basliklar.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YazilarCollectionViewCell", for: indexPath) as! YazilarCollectionViewCell
        

        cell.baslik.text = basliklar[indexPath.row].html2String
        cell.yazarAvatar.sd_setImage(with: URL(string: catResim[indexPath.row]), placeholderImage: UIImage(named: "faiklogo"))
        cell.haberGorseli.sd_setImage(with: URL(string: resimLink[indexPath.row]), placeholderImage: UIImage(named: "faiklogo"))
        cell.yazarAvatar.layer.cornerRadius = cell.yazarAvatar.frame.height/2
        cell.yazarAvatar.clipsToBounds = true
        
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.25
        cell.layer.shadowOffset = CGSize(width: 0, height: 5)
        cell.layer.shadowRadius = 12
        cell.layer.masksToBounds = false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedItem = yazinumara[indexPath.row]
        let videoItem = videoLink[indexPath.row]
        let formatItem = format[indexPath.row]
        
        let mDetayViewController = DetayViewController(nibName: "DetayViewController", bundle: nil)
        mDetayViewController.yaziNumara = selectedItem
        mDetayViewController.yaziFormat = formatItem
        mDetayViewController.videoLink = videoItem
        self.navigationController?.pushViewController(mDetayViewController, animated: true)
        
    }
    
    func jsonToString(json: AnyObject) -> String{
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            print(convertedString ?? "defaultvalue")
            
            return convertedString!
        } catch let myJSONError {
            print(myJSONError)
            return "HATA"
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
        
        effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2 , y: view.frame.midY - strLabel.frame.height/2 , width: 160, height: 46)
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
