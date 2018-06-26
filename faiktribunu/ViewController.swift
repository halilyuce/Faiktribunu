//
//  ViewController.swift
//  faiktribunu
//
//  Created by Halil İbrahim YÜCE on 28.05.2018.
//  Copyright © 2018 Halil İbrahim YÜCE. All rights reserved.
//

import UIKit
import PSHTMLView

let postUrl = URL(string:StaticVariables.baseUrl + StaticVariables.postUrl)!
let postData = try! Data(contentsOf: postUrl)
var jsonDecoder = JSONDecoder()

var basliklar = [String]()
var catStr = [String]()
var catResim = [String]()
var resimStr = [String]()
var resimLink = [String]()



class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let fav = UIButton(type: .custom)
        fav.setImage(UIImage(named: "television"), for: .normal)
        fav.addTarget(self, action: #selector(self.FavMethod), for: .touchUpInside)
        let favbtn = UIBarButtonItem(customView: fav)
        
        fav.widthAnchor.constraint(equalToConstant: 32.0).isActive = true
        fav.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
    

        self.navigationItem.setRightBarButtonItems([favbtn], animated: true)
        

        self.setupNavigationBar(image: UIImage(named: "navlogo")!)
        
        
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
                
            }
        }
        
      
        
       
        
        
    }
    
    @objc func FavMethod(){
        
    }

   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return basliklar.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! CollectionViewCell
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



