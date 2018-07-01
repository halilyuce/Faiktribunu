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

class YazilarViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var mCollectionView: UICollectionView!
    
    var basliklar = [String]()
    var resimStr = String()
    var resimLink = [String]()
    var catResim = [String]()
    var base = [Base]()
    var resBase = [ResBase]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mCollectionView.register(YazilarCollectionViewCell.self, forCellWithReuseIdentifier: "YazilarCollectionViewCell")
        mCollectionView.register(UINib.init(nibName: "YazilarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "YazilarCollectionViewCell")

        self.mCollectionView.delegate = self
        
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
        cell.yazarAvatar.downloadedFrom(link: catResim[indexPath.row])
        cell.haberGorseli.downloadedFrom(link: resimLink[indexPath.row])
        cell.yazarAvatar.layer.cornerRadius = cell.yazarAvatar.frame.height/2
        cell.yazarAvatar.clipsToBounds = true
        
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.25
        cell.layer.shadowOffset = CGSize(width: 0, height: 5)
        cell.layer.shadowRadius = 12
        cell.layer.masksToBounds = false
        return cell
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
    


}
