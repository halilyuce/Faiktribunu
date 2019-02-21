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

class DetayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var resimStr = String()
    var authorName = String()
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
    var contentHeight = CGFloat()
    var isWebViewLoaded = Bool()
    var yazarAvatar = String()
    
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
        
        self.tableView.register(infoCell.self, forCellReuseIdentifier: "infoCell")
        self.tableView.register(ContentCell.self, forCellReuseIdentifier: "ContentCell")
        self.tableView.register(CommentsCell.self, forCellReuseIdentifier: "CommentsCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorInset = .zero
        tableView.layoutMargins = .zero
        
        let share = UIButton(type: .custom)
        share.setImage(UIImage(named: "share"), for: UIControl.State.normal)
        share.addTarget(self, action: #selector(self.shareMethod), for: UIControl.Event.touchUpInside)
        
        share.widthAnchor.constraint(equalToConstant: 28.0).isActive = true
        share.heightAnchor.constraint(equalToConstant: 28.0).isActive = true
        
        loadPost{ () -> () in
            
            let imageView = UIImageView()
            imageView.sd_setImage(with: URL(string: self.resimStr), completed: nil)
            imageView.contentMode = .scaleAspectFill
            imageView.isUserInteractionEnabled = true
            
            imageView.blurView.setup(style: UIBlurEffect.Style.dark, alpha: 0).enable()
            
            let buttonBack = UIButton()
            buttonBack.setAttributedTitle(NSAttributedString.init(string: "< Geri", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .bold), NSAttributedString.Key.foregroundColor : UIColor.black]), for: UIControl.State.normal)
            buttonBack.isUserInteractionEnabled = true
            buttonBack.isEnabled = true
            buttonBack.backgroundColor = .white
            buttonBack.setTitleColor(UIColor.black, for: .normal)
            buttonBack.translatesAutoresizingMaskIntoConstraints = false
            
            imageView.addSubview(buttonBack)
            
            buttonBack.leftAnchor.constraint(equalTo: imageView.leftAnchor, constant: 15).isActive = true
            buttonBack.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 15).isActive = true
            buttonBack.widthAnchor.constraint(equalToConstant: 72).isActive = true
            buttonBack.heightAnchor.constraint(equalToConstant: 32).isActive = true
            
            buttonBack.clipsToBounds = true
            buttonBack.layer.cornerRadius = 16
            
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
            
            
            self.effectView.removeFromSuperview()
            self.tableView.reloadData()
            
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
                            
                            if let resimLarge = detay.betterimage?.details?.sizes?.large?.source{
                                self.resimStr = (detay.betterimage?.details?.sizes?.large?.source)!
                            }else{
                                self.resimStr = (detay.betterimage?.details?.sizes?.medium?.source)!
                            }
                            
                            self.authorName = (detay.author?.name)!
                            
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
        
        if indexPath.row == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! infoCell
            cell.title.text = baslik.uppercased()
            cell.avatarName.text = authorName
            cell.avatar.sd_setImage(with: URL(string: yazarAvatar), completed: nil)
            return cell
            
        }else if indexPath.row == 1{
           
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentCell", for: indexPath) as! ContentCell
            
            let htmlHeight = contentHeight
            
            cell.body.delegate = self
            cell.body.loadHTMLString("<meta name=\"viewport\" content=\"width=device-width, maximum-scale=1, user-scalable=no, initial-scale=1\"> <style>body{font-size:18px} .wp-caption{max-width:100%;background:#eee;padding: 5px;} .wp-caption img{max-width:100%;height:auto;width: 100%;} .entry-content img {max-width:100%;height:auto;} img{display:inline; height:auto; max-width:100%;} embed, iframe, object {max-width:100%;height:225px;}</style>" + content, baseURL: nil)
            cell.body.frame = CGRect(x:0, y:0, width:cell.frame.size.width - 30, height:htmlHeight)
            cell.body.scrollView.isScrollEnabled = false

            
            return cell
            
        }else if indexPath.row == 2{
           
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsCell", for: indexPath) as! CommentsCell
            cell.backgroundColor = .green
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentCell", for: indexPath) as! ContentCell
            return cell
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0{
            return 220
        }
        
        if indexPath.row == 1{
            
            if contentHeight != 60.0{
                
                return contentHeight + 30
            }else{
                return 0
            }
            
            }
        
        if indexPath.row == 2{
            return 200
        }
        
        else{
            return 0
        }
        
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        var frame : CGRect = webView.frame
        frame.size.height = 1
        webView.frame.size = webView.sizeThatFits(.zero)
        frame.size = webView.frame.size
        webView.frame = frame
        contentHeight = webView.frame.size.height
        isWebViewLoaded = true
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        })
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
        _ = navigationController?.popViewController(animated: true)
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

class infoCell: UITableViewCell {
    
    let title: UILabel = {
        let button = UILabel()
        button.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        button.textAlignment = .left
        button.numberOfLines = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let clapsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let claps: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "claps"), for: UIControl.State.normal)
        button.setAttributedTitle(NSAttributedString.init(string: "17", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular), NSAttributedString.Key.foregroundColor : UIColor.black]), for: UIControl.State.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let seperator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let favoriteView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let avatar: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let avatarName: UILabel = {
        let button = UILabel()
        button.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.textAlignment = .left
        button.numberOfLines = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let favorite: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "bookmarks"), for: UIControl.State.normal)
        button.setAttributedTitle(NSAttributedString.init(string: "Favorilere Al", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .regular), NSAttributedString.Key.foregroundColor : UIColor.black]), for: UIControl.State.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let commentsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let comments: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "comments"), for: UIControl.State.normal)
        button.setAttributedTitle(NSAttributedString.init(string: "Yorumlar", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .regular), NSAttributedString.Key.foregroundColor : UIColor.black]), for: UIControl.State.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let shareView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let share: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "shareit"), for: UIControl.State.normal)
        button.setAttributedTitle(NSAttributedString.init(string: "Paylaş", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .regular), NSAttributedString.Key.foregroundColor : UIColor.black]), for: UIControl.State.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        
        addSubview(title)
        
        title.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        title.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        title.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        title.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        addSubview(clapsView)
        
        clapsView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        clapsView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10).isActive = true
        clapsView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        clapsView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 4).isActive = true
        
        clapsView.addSubview(claps)
        
        claps.centerXAnchor.constraint(equalTo: clapsView.centerXAnchor).isActive = true
        claps.centerYAnchor.constraint(equalTo: clapsView.centerYAnchor).isActive = true
        claps.heightAnchor.constraint(equalToConstant: 60).isActive = true
        claps.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width / 4) - 20).isActive = true
        
        addSubview(favoriteView)
        
        favoriteView.leftAnchor.constraint(equalTo: clapsView.rightAnchor).isActive = true
        favoriteView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10).isActive = true
        favoriteView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        favoriteView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 4).isActive = true
        
        favoriteView.addSubview(favorite)
        
        favorite.centerXAnchor.constraint(equalTo: favoriteView.centerXAnchor).isActive = true
        favorite.centerYAnchor.constraint(equalTo: favoriteView.centerYAnchor).isActive = true
        favorite.heightAnchor.constraint(equalToConstant: 60).isActive = true
        favorite.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 4).isActive = true
        
        addSubview(commentsView)
        
        commentsView.leftAnchor.constraint(equalTo: favoriteView.rightAnchor).isActive = true
        commentsView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10).isActive = true
        commentsView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        commentsView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 4).isActive = true
        
        commentsView.addSubview(comments)
        
        comments.centerXAnchor.constraint(equalTo: commentsView.centerXAnchor).isActive = true
        comments.centerYAnchor.constraint(equalTo: commentsView.centerYAnchor).isActive = true
        comments.heightAnchor.constraint(equalToConstant: 60).isActive = true
        comments.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width / 4) - 20).isActive = true
        
        
        addSubview(shareView)
        
        shareView.leftAnchor.constraint(equalTo: commentsView.rightAnchor).isActive = true
        shareView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10).isActive = true
        shareView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        shareView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 4).isActive = true
        
        shareView.addSubview(share)
        
        share.centerXAnchor.constraint(equalTo: shareView.centerXAnchor).isActive = true
        share.centerYAnchor.constraint(equalTo: shareView.centerYAnchor).isActive = true
        share.heightAnchor.constraint(equalToConstant: 60).isActive = true
        share.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width / 4) - 20).isActive = true
        
        claps.centerVertically(padding: 4)
        claps.imageView?.contentMode = .scaleAspectFit
        claps.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        
        favorite.centerVertically(padding: 4)
        favorite.imageView?.contentMode = .scaleAspectFit
        favorite.imageEdgeInsets = UIEdgeInsets(top: 2, left: 10, bottom: 2, right: 0)
        
        comments.centerVertically(padding: 4)
        comments.imageView?.contentMode = .scaleAspectFit
        comments.imageEdgeInsets = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
        
        share.centerVertically(padding: 4)
        share.imageView?.contentMode = .scaleAspectFit
        share.imageEdgeInsets = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
        
        addSubview(seperator)
        
        seperator.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        seperator.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        seperator.topAnchor.constraint(equalTo: share.bottomAnchor, constant: 20).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        addSubview(avatar)
        
        avatar.leftAnchor.constraint(equalTo: leftAnchor, constant: 25).isActive = true
        avatar.topAnchor.constraint(equalTo: seperator.bottomAnchor, constant: 8).isActive = true
        avatar.heightAnchor.constraint(equalToConstant: 36).isActive = true
        avatar.widthAnchor.constraint(equalToConstant: 36).isActive = true
        
        avatar.layer.cornerRadius = 18
        avatar.clipsToBounds = true
        
        addSubview(avatarName)
        
        avatarName.leftAnchor.constraint(equalTo: avatar.rightAnchor, constant: 10).isActive = true
        avatarName.topAnchor.constraint(equalTo: seperator.bottomAnchor, constant: 6).isActive = true
        avatarName.heightAnchor.constraint(equalToConstant: 42).isActive = true
        avatarName.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 3).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



class ContentCell: UITableViewCell {
    
    let body: UIWebView = {
        let name = UIWebView()
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

class CommentsCell: UITableViewCell {
    
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
