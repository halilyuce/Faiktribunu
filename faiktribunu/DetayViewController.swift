//
//  DetayViewController.swift
//  faiktribunu
//
//  Created by Halil İbrahim YÜCE on 29.06.2018.
//  Copyright © 2018 Halil İbrahim YÜCE. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ObjectMapper
import WebKit
import AVKit
import Crashlytics
import ParallaxHeader
import SnapKit

class DetayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var resimStr = String()
    var resimUrl = String()
    var resimShare = String()
    var baslik = String()
    var content = String()
    var base = [Base]()
    var detayBase = [Title]()
    var resBase = [ResBase]()
    var yaziNumara = String()
    var yaziFormat = String()
    var videoLink = String()
    
    var showBackButton = false
    
    let imagePicker = UIImagePickerController()
    let messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        UIApplication.shared.keyWindow?.windowLevel = UIWindow.Level.statusBar
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        UIApplication.shared.keyWindow?.windowLevel = UIWindow.Level.normal
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(ContentCell.self, forCellReuseIdentifier: "ContentCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let share = UIButton(type: .custom)
        share.setImage(UIImage(named: "share"), for: UIControl.State.normal)
        share.addTarget(self, action: #selector(self.shareMethod), for: UIControl.Event.touchUpInside)
        
        share.widthAnchor.constraint(equalToConstant: 28.0).isActive = true
        share.heightAnchor.constraint(equalToConstant: 28.0).isActive = true
        
        loadPost{ () -> () in
            
            
            let imageView = UIImageView()
            imageView.sd_setImage(with: URL(string: self.resimStr), completed: nil)
            imageView.contentMode = .scaleAspectFill
            
            imageView.blurView.setup(style: UIBlurEffect.Style.dark, alpha: 0).enable()
            
            let buttonBack = UIButton()
            buttonBack.setTitle("< Geri", for: .normal)
            buttonBack.tintColor = UIColor.white
            buttonBack.isUserInteractionEnabled = true
            buttonBack.isEnabled = true
            buttonBack.setTitleColor(UIColor.white, for: .normal)
            buttonBack.translatesAutoresizingMaskIntoConstraints = false
            
            imageView.addSubview(buttonBack)
            
            buttonBack.leftAnchor.constraint(equalTo: imageView.leftAnchor, constant: 15).isActive = true
            buttonBack.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 15).isActive = true
            buttonBack.widthAnchor.constraint(equalToConstant: 128)
            buttonBack.heightAnchor.constraint(equalToConstant: 36)
            
            self.tableView.parallaxHeader.view = imageView
            self.tableView.parallaxHeader.height = 240
            self.tableView.parallaxHeader.minimumHeight = 70
            self.tableView.parallaxHeader.mode = .centerFill
            self.tableView.parallaxHeader.parallaxHeaderDidScrollHandler = { parallaxHeader in
                //update alpha of blur view on top of image view
                parallaxHeader.view.blurView.alpha = 1 - parallaxHeader.progress
            }
            
            // Label for vibrant text
            let vibrantLabel = UILabel()
            vibrantLabel.text = self.baslik
            vibrantLabel.font = UIFont.systemFont(ofSize: 16.0)
            vibrantLabel.numberOfLines = 2
            vibrantLabel.sizeToFit()
            vibrantLabel.textAlignment = .center
            imageView.blurView.vibrancyContentView?.addSubview(vibrantLabel)
            //add constraints using SnapKit library
            vibrantLabel.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            
            buttonBack.addTarget(self, action: #selector(self.backTouch), for: UIControl.Event.touchUpInside)
            
        }
        
        
        
        self.activityIndicator("Yükleniyor")
        
    }
    
    func loadPost(handleComplete:@escaping (()->())){
        
        let detayUrl = StaticVariables.baseUrl + "posts/\(yaziNumara)"
        AF.request(detayUrl, method: .get, parameters: nil)
            .responseString { response in
                switch(response.result) {
                case .success(_):
                    if let ddata = response.data, let dutf8Text = String(data: ddata, encoding: .utf8) {
                        if let detay = Mapper<DetayList>().map(JSONString: dutf8Text){
                            
                            self.baslik.append((detay.title?.rendered?.html2String)!)
                            
                            self.resimStr = (detay.betterimage?.details?.sizes?.large?.source)!
                            
                            Answers.logContentView(withName: self.baslik,
                                                   contentType: "yazi",
                                                   contentId: self.yaziNumara,
                                                   customAttributes: [:])
                            
                            
                            if self.yaziFormat == "video" {
                                
                                self.content = (detay.content?.rendered)!
                                //self.videoLink
                                
                                
                            } else{
                                
                                self.content = (detay.content?.rendered)!
                                
                            }
                            
                            self.effectView.removeFromSuperview()
                            self.tableView.reloadData()
                            
                            
                        }
                    }
                    else{
                        print("hatalı json")
                    }
                case .failure(_):
                    print("Error message:\(String(describing: response.result.error))")
                    break
                }
                handleComplete()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentCell", for: indexPath) as! ContentCell
        cell.body.text = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let approximateWidthOfBodyTextView = UIScreen.main.bounds.width - 30
        
        let bodySize = CGSize(width: approximateWidthOfBodyTextView, height:1000)
        let bodyAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        
        let estimatedBodyFrame = NSString(string: content).boundingRect(with: bodySize, options: . usesLineFragmentOrigin, attributes: bodyAttributes, context: nil)
        
        return estimatedBodyFrame.height + 32
    }
    
    
    @objc func shareMethod(){

        let string: String = baslik
        let URL: String = "http://faiktribunu.com/?p=\(yaziNumara)"
        
        Answers.logShare(withMethod: "Paylasim",
                                   contentName: baslik,
                                   contentType: "share",
                                   contentId: yaziNumara,
                                   customAttributes: [:])
        
        let activityViewController = UIActivityViewController(activityItems: [string, URL], applicationActivities: nil)
        navigationController?.present(activityViewController, animated: true) {
        }
        
        
    }
    
    
    
    @objc func backTouch(){
        print("back")
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    func activityIndicator(_ title: String) {
        
        strLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()
        
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 160, height: 46))
        strLabel.text = title
        strLabel.font = .systemFont(ofSize: 14, weight: .medium)
        strLabel.textColor = UIColor(white: 0.9, alpha: 0.7)
        
        effectView.frame = CGRect(x: StaticVariables.screenWidth/2 - strLabel.frame.width/2 , y: StaticVariables.screenHeight/2 - strLabel.frame.height * 2 , width: 160, height: 46)
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


class ContentCell: UITableViewCell {
    
    let body: UILabel = {
        let name = UILabel()
        name.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        name.numberOfLines = 0
        name.textColor = UIColor.black
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        setupViews()
    }
    
    
    func setupViews(){
        
    }
    
    func addViews(){
        backgroundColor = UIColor.white
        
        addSubview(body)
        
        body.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        body.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        body.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        body.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 10).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
