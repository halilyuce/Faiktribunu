//
//  YazilarViewController.swift
//  faiktribunu
//
//  Created by Halil İbrahim YÜCE on 28.06.2018.
//  Copyright © 2018 Halil İbrahim YÜCE. All rights reserved.
//

import UIKit
import PSHTMLView

class YazilarViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var mCollectionView: UICollectionView!
    
    let postUrl = URL(string:StaticVariables.baseUrl + StaticVariables.postUrl)!
    
    var jsonDecoder = JSONDecoder()
    
    var basliklar = [String]()
    var catStr = [String]()
    var catResim = [String]()
    var resimStr = [String]()
    var resimLink = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mCollectionView.register(YazilarCollectionViewCell.self, forCellWithReuseIdentifier: "YazilarCollectionViewCell")
        mCollectionView.register(UINib.init(nibName: "YazilarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "YazilarCollectionViewCell")
        
        let postData = try! Data(contentsOf: postUrl)
        self.mCollectionView.delegate = self
        let yazilar = try? jsonDecoder.decode([Yazilar].self, from: postData)
        if let yazi = yazilar {
            for y in yazi{
                
                basliklar.append(y.title.rendered)
                resimStr.append("\(y.featured_media)")
                catStr.append("\(y.categories[0])")
                
                let resUrl = URL(string: StaticVariables.baseUrl + StaticVariables.resimUrl + "\(y.featured_media)")
                let resimData = try! Data(contentsOf: resUrl!)
                let resimler = try? jsonDecoder.decode(Resim.self, from: resimData)
                resimLink.append((resimler?.guid.rendered)!)
                
                catResim.append(StaticVariables.homeUrl + StaticVariables.catAvatar + "\(y.categories[0])" + ".png")
                self.mCollectionView.reloadData()
                /*if y.featured_media == yazi[yazi.count - 1].featured_media{
                  //
                }*/
                
            }
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

}
