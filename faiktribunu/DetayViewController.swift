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
import NightNight
import SDWebImage
import XCDYouTubeKit


class DetayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var resimStr = String()
    var authorName = String()
    var resimUrl = String()
    var resimShare = String()
    var baslik = String()
    var content = String()
    var tarih = String()
    var base = [Base]()
    var detayBase = [Title]()
    var resBase = [ResBase]()
    var yaziNumara = String()
    var yaziFormat = String()
    var videoLink = String()
    var contentHeight = 1
    var isWebViewLoaded = Bool()
    var yazarAvatar = String()
    var ilkResim = UIImage()
    var itemSize = Bool()
    let defaults = UserDefaults.standard
    var favoriler = [Int]()
    var contentID = String()
    
    var commentUserName = [String]()
    var commentUserAvatar = [String]()
    var commentBody = [String]()
    
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
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? infoCell
        cell?.isHidden = true
        tableView.reloadData()
        
        favoriler = defaults.array(forKey: "Favoriler")  as? [Int] ?? [Int]()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        UIApplication.shared.keyWindow?.windowLevel = UIWindow.Level.normal
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemSize = false
        
        tableView.tableFooterView = UIView()
        
        self.tableView.register(infoCell.self, forCellReuseIdentifier: "infoCell")
        self.tableView.register(ContentCell.self, forCellReuseIdentifier: "ContentCell")
        self.tableView.register(CommentsCell.self, forCellReuseIdentifier: "CommentsCell")
        
        view.mixedBackgroundColor = MixedColor(normal: UIColor.groupTableViewBackground, night: UIColor(hexString: "#282828"))
        tableView.mixedBackgroundColor = MixedColor(normal: UIColor.groupTableViewBackground, night: UIColor(hexString: "#282828"))
        
        tableView.mixedSeparatorColor = MixedColor(normal: UIColor.lightGray, night: UIColor(hexString: "#3f4447"))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorInset = .zero
        tableView.layoutMargins = .zero
        
        
            let imageView = UIImageView()
            imageView.image = ilkResim
            imageView.contentMode = .scaleAspectFill
            imageView.isUserInteractionEnabled = true
            imageView.blurView.setup(style: UIBlurEffect.Style.dark, alpha: 0).enable()
            
            let buttonBack = UIButton()
            buttonBack.setTitle("< Geri", for: UIControl.State.normal)
            buttonBack.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
            buttonBack.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: UIControl.State.normal)
            buttonBack.isUserInteractionEnabled = true
            buttonBack.isEnabled = true
            buttonBack.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            buttonBack.translatesAutoresizingMaskIntoConstraints = false
            
            imageView.addSubview(buttonBack)
            
            buttonBack.leftAnchor.constraint(equalTo: imageView.leftAnchor, constant: 15).isActive = true
            buttonBack.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 15).isActive = true
            buttonBack.widthAnchor.constraint(equalToConstant: 72).isActive = true
            buttonBack.heightAnchor.constraint(equalToConstant: 32).isActive = true
            
            buttonBack.clipsToBounds = true
            buttonBack.layer.cornerRadius = 16
        
            buttonBack.addTarget(self, action: #selector(self.backTouch), for: UIControl.Event.touchUpInside)
        
            if yaziFormat == "video"{
                
                let playVideo = UIButton()
                let image = UIImage(named: "play-button")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                playVideo.setImage(image, for: UIControl.State.normal)
                playVideo.tintColor = .white
                playVideo.contentEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
                playVideo.isUserInteractionEnabled = true
                playVideo.isEnabled = true
                playVideo.backgroundColor = UIColor.red.withAlphaComponent(0.8)
                playVideo.translatesAutoresizingMaskIntoConstraints = false
                
                imageView.addSubview(playVideo)
                
                playVideo.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
                playVideo.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
                playVideo.widthAnchor.constraint(equalToConstant: 52).isActive = true
                playVideo.heightAnchor.constraint(equalToConstant: 52).isActive = true
                
                playVideo.clipsToBounds = true
                playVideo.layer.cornerRadius = 26
                
                playVideo.addTarget(self, action: #selector(self.playVideo), for: UIControl.Event.touchUpInside)
            
            
            }
            
            self.tableView.parallaxHeader.view = imageView
            self.tableView.parallaxHeader.height = 240
            self.tableView.parallaxHeader.minimumHeight = 70
            self.tableView.parallaxHeader.mode = .centerFill
            self.tableView.parallaxHeader.parallaxHeaderDidScrollHandler = { parallaxHeader in
                //update alpha of blur view on top of image view
                parallaxHeader.view.blurView.alpha = 1 - parallaxHeader.progress
            }
            
            loadPost{ () -> () in
                
                self.itemSize = true
                
                imageView.sd_setImage(with: URL(string: self.resimStr), completed: nil)
                
                if self.yaziFormat != "video"{
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
                    
                }
                
                self.effectView.removeFromSuperview()
                self.tableView.reloadData()
                
            }
            
        
        loadComments{ () -> () in
        }
        
        self.activityIndicator("Yükleniyor")
        
    }
    
    struct YouTubeVideoQuality {
        static let hd720 = NSNumber(value: XCDYouTubeVideoQuality.HD720.rawValue)
        static let medium360 = NSNumber(value: XCDYouTubeVideoQuality.medium360.rawValue)
        static let small240 = NSNumber(value: XCDYouTubeVideoQuality.small240.rawValue)
    }
    
    @objc func playVideo(){
        
        let playerViewController = AVPlayerViewController()
        self.present(playerViewController, animated: true, completion: nil)
        
        XCDYouTubeClient.default().getVideoWithIdentifier(videoLink) { [weak playerViewController] (video: XCDYouTubeVideo?, error: Error?) in
            if let streamURLs = video?.streamURLs, let streamURL = (streamURLs[XCDYouTubeVideoQualityHTTPLiveStreaming] ?? streamURLs[YouTubeVideoQuality.hd720] ?? streamURLs[YouTubeVideoQuality.medium360] ?? streamURLs[YouTubeVideoQuality.small240]) {
                playerViewController?.player = AVPlayer(url: streamURL)
                playerViewController?.player?.play()
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    func loadComments(handleComplete:@escaping (()->())){
        
        
        let commentsUrl = StaticVariables.baseUrl + "comments?post=" + contentID
        
        AF.request(commentsUrl, method: .get, parameters: nil)
            .responseString { response in
                switch(response.result) {
                case .success(_):
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        
                        let jsonString: String = "{\"lst\":" + utf8Text + "}"
                        
                        if let itemsMap = Mapper<CommentsList>().map(JSONString: jsonString){
                            
                            let items = itemsMap.lst!
                            
                            for item in items{
                                self.commentUserName.append(item.authorName!)
                                self.commentBody.append((item.content?.rendered)!)
                                self.commentUserAvatar.append((item.authorAvatarUrls)!)
                                
                                if items.last?.id == item.id{
                                    self.tableView.reloadData()
                                    self.tableView.layoutIfNeeded()
                                    
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
                            
                            
                            let string = detay.date
                            let dateTo = DateFormatter.date(fromISO8601String: string!)
                            self.tarih.append(dateTo!.getElapsedInterval())
                            
                            
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        }else if section == 2 {
            return commentUserName.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 2 {
            let sectionHeader = UIView()
            sectionHeader.mixedBackgroundColor = MixedColor(normal: UIColor.groupTableViewBackground, night: UIColor(hexString: "#3f4447"))
            
            let label = UILabel()
            label.frame = CGRect(x: 15, y: 10, width: UIScreen.main.bounds.width - 165, height: 30)
            
            if commentUserName.count != 0{
                label.text = "Bu gönderi için \(commentUserName.count) yorum var"
            }else{
                label.text = "Henüz bir yorum eklenmemiş"
            }
            
            label.font = UIFont.systemFont(ofSize: 15)
            label.mixedTextColor = MixedColor(normal: UIColor.black, night: UIColor.white)
            sectionHeader.addSubview(label)
            
            let button = UIButton()
            button.frame = CGRect(x: UIScreen.main.bounds.width - 125, y: 10, width: 100, height: 30)
            button.setTitle("Yorum Yap", for: UIControl.State.normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
            button.backgroundColor = UIColor.black
            button.clipsToBounds = true
            button.layer.cornerRadius = 15
            sectionHeader.addSubview(button)
            
            button.addTarget(self, action: #selector(self.addComment), for: UIControl.Event.touchUpInside)
            
            return sectionHeader
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
        return 50
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! infoCell
            cell.selectionStyle = .none
            
            
            if self.itemSize == true{
            cell.isHidden = false
            cell.title.text = baslik.uppercased()
            cell.claps.setTitle(tarih, for: UIControl.State.normal)
            cell.title.mixedTextColor = MixedColor(normal: UIColor.black, night: UIColor.white.withAlphaComponent(0.8))
            cell.avatarName.text = authorName
            cell.avatarName.mixedTextColor = MixedColor(normal: UIColor.black, night: UIColor.white.withAlphaComponent(0.8))
            cell.avatar.sd_setImage(with: URL(string: yazarAvatar), completed: nil)
                cell.favorite.tag = indexPath.row
                cell.favorite.addTarget(self, action: #selector(self.clickFavorite), for: UIControl.Event.touchUpInside)
                
                if favoriler.contains(Int(yaziNumara)!){
                    cell.favorite.isSelected = true
                    cell.favorite.mixedTintColor = MixedColor(normal: UIColor.orange.withAlphaComponent(1.0), night: UIColor.orange.withAlphaComponent(1.0))
                    cell.favorite.setTitle("Favorilerinizde", for: UIControl.State.normal)
                }else{
                     cell.favorite.isSelected = false
                    cell.favorite.mixedTintColor = MixedColor(normal: UIColor.black, night: UIColor.white.withAlphaComponent(0.5))
                    cell.favorite.setTitle("Favorilere Ekle", for: UIControl.State.normal)
                }
                
                cell.share.addTarget(self, action: #selector(self.shareMethod), for: UIControl.Event.touchUpInside)
                
                cell.comments.addTarget(self, action: #selector(self.goComments), for: UIControl.Event.touchUpInside)
                
                
            }else{
                cell.isHidden = true
            }
            return cell
            
        }else if indexPath.section == 1{
           
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentCell", for: indexPath) as! ContentCell
            cell.selectionStyle = .none
            
            if self.itemSize == true{
                cell.isHidden = false
            let htmlHeight = contentHeight
            
            cell.body.delegate = self
                
            
            let colorSwitches = UserDefaults.standard.bool(forKey: "colormode")
            
            if colorSwitches == true{
                
                cell.body.loadHTMLString("<meta name=\"viewport\" content=\"width=device-width, maximum-scale=1, user-scalable=no, initial-scale=1\"> <style>body{font-family:Arial,Helvetica,sans-serif;font-size:18px;background-color:#282828;color:#d8d8d8} .wp-caption{max-width:100%;background:#eee;padding: 5px;} .wp-caption img{max-width:100%;height:auto;width: 100%;} .entry-content img {max-width:100%;height:auto;} img{display:inline; height:auto; max-width:100%;} embed, iframe, object {max-width:100%;height:225px;}</style>" + content, baseURL: nil)
                
            }else{
                cell.body.loadHTMLString("<meta name=\"viewport\" content=\"width=device-width, maximum-scale=1, user-scalable=no, initial-scale=1\"> <style>body{font-family:Arial,Helvetica,sans-serif;font-size:18px} .wp-caption{max-width:100%;background:#eee;padding: 5px;} .wp-caption img{max-width:100%;height:auto;width: 100%;} .entry-content img {max-width:100%;height:auto;} img{display:inline; height:auto; max-width:100%;} embed, iframe, object {max-width:100%;height:225px;}</style>" + content, baseURL: nil)
            }
            
                cell.body.frame = CGRect(x: 0, y: 0, width: Int(cell.frame.width), height: htmlHeight)
                cell.body.scrollView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                cell.body.scrollView.isScrollEnabled = false
            
            }else{
                cell.isHidden = true
            }
            
            return cell
            
        }else if indexPath.section == 2{
           
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsCell", for: indexPath) as! CommentsCell
            cell.selectionStyle = .none
            
            if self.itemSize == true{
                cell.isHidden = false
                
                cell.avatar.sd_setImage(with: URL(string: commentUserAvatar[indexPath.row]), placeholderImage: nil, options: SDWebImageOptions.refreshCached, progress: nil, completed: { (image, error, cache, url) in
                    if ((image) != nil){
                        cell.avatar.image = image
                    }else{
                        cell.avatar.sd_setImage(with: URL(string: "https://www.faiktribunu.com/wp-content/uploads/2018/01/faikkartal-125x125.png"))
                    }
                })
                
                cell.avatarName.text = commentUserName[indexPath.row]
                cell.body.text = commentBody[indexPath.row].html2String
                
                cell.layer.addBorder(edge: UIRectEdge.top, color: MixedColor(normal: UIColor.groupTableViewBackground, night: UIColor.black), thickness: 0.5)
                
                
            }else{
                cell.isHidden = true
            }
            
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentCell", for: indexPath) as! ContentCell
            cell.selectionStyle = .none
            
            if self.itemSize == true{
                cell.isHidden = false
                
                
            }else{
                cell.isHidden = true
            }
            
            return cell
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.itemSize == true{
        
        if indexPath.section == 0{
            return 220
        }
        
        if indexPath.section == 1{
            
            if (contentHeight != 0)
            {
                if contentHeight != 8{
                   return CGFloat(contentHeight)
                }else{
                    return 0
                }
            }
            
            
            }
        
        if indexPath.section == 2{
            
            let approximateWidthOfBodyTextView = UIScreen.main.bounds.width - 86
            
            let bodySize = CGSize(width: approximateWidthOfBodyTextView, height:1000)
            let bodyAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
            
            let estimatedBodyFrame = NSString(string: commentBody[indexPath.row].html2String).boundingRect(with: bodySize, options: . usesLineFragmentOrigin, attributes: bodyAttributes, context: nil)
            
            return estimatedBodyFrame.height + 52
            
        }
        
        else{
            return 0
        }
            
            
            
        }else{
            return 0
        }
        
    }
    
    @objc func addComment(){
        print("yorum yap")
        
        let alert = UIAlertController(title: "Yorum Ekle", message: "Lütfen yorum yaparken yazım kurallarına dikkat edin ve argo, hakaret ve küfür vb. sözlerden kaçınınız.", preferredStyle: .alert)
        
        let save = UIAlertAction(title: "Yorum Yap", style: .default) { (alertAction) in
 
            let isim = alert.textFields![0] as UITextField
            let yorum = alert.textFields![1] as UITextField
            
            if isim.text != "" && yorum.text != ""{
                
                self.activityIndicator("Gönderiliyor")
                
                let urlString = "https://www.faiktribunu.com/wp-json/wp/v2/comments"
                
                let params: Parameters = [
                    "post": self.yaziNumara,
                    "author_name": isim.text!,
                    "content": yorum.text!
                ]
                
                AF.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON {
                    response in
                    
                    self.commentUserName.removeAll(keepingCapacity: false)
                    self.commentBody.removeAll(keepingCapacity: false)
                    self.commentUserAvatar.removeAll(keepingCapacity: false)
                    
                    switch response.result {
                    case .success:
                        
                        self.loadComments{ () -> () in
                            self.effectView.removeFromSuperview()
                        }
                        
                        break
                    case .failure(let error):
                        
                        print(error)
                    }
                }

                
                
            } else {
                
                let alert = UIAlertController(title: "Bir Hata Meydana Geldi", message: "Görünüşe göre İsim veya Yorum alanlarından birini boş bırakmışsınız", preferredStyle: .actionSheet)
                
                let cancel = UIAlertAction(title: "Anladım", style: .cancel) { (alertAction) in }
                alert.addAction(cancel)
                
                self.present(alert, animated:true, completion: nil)
            }
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "İsminizi Yazınız"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Yorumunuzu Yazınız"
        }
        
        alert.addAction(save)
        let cancel = UIAlertAction(title: "Vazgeç", style: .destructive) { (alertAction) in }
        alert.addAction(cancel)
        
        
        self.present(alert, animated:true, completion: nil)
        
    }
    
    @objc func clickFavorite(sender:UIButton){
        
        let currentCellNumber = sender.tag
        let indexPath = IndexPath(row: currentCellNumber, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! infoCell
        
        if sender.isSelected == false {
            print("selected")
            print(favoriler)
            
            if favoriler.contains(Int(yaziNumara)!){
                print("zaten var")
            }else{
                favoriler.append(Int(yaziNumara)!)
                defaults.set(favoriler, forKey: "Favoriler")
            }
            
            cell.favorite.isSelected = true
            cell.favorite.setTitle("Favorilerinizde", for: UIControl.State.normal)
            cell.favorite.mixedTintColor = MixedColor(normal: UIColor.orange.withAlphaComponent(1.0), night: UIColor.orange.withAlphaComponent(1.0))
        }else{
            print("unselected")
            
            if favoriler.contains(Int(yaziNumara)!){
                let index = favoriler.firstIndex(of: Int(yaziNumara)!)
                favoriler.remove(at: index!)
                defaults.set(favoriler, forKey: "Favoriler")
            }else{
                print("zaten yok")
            }
            
            cell.favorite.isSelected = false
            cell.favorite.setTitle("Favorilere Ekle", for: UIControl.State.normal)
            cell.favorite.mixedTintColor = MixedColor(normal: UIColor.black, night: UIColor.white.withAlphaComponent(0.5))
        }
        print(favoriler)
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        if (contentHeight != 1)
        {
            // we already know height, no need to reload cell
            return
        }
        
        var frame: CGRect = webView.frame
        frame.size.height = 1
        webView.frame = frame
        let fittingSize = webView.sizeThatFits(CGSize.zero)
        frame.size = fittingSize
        webView.frame = frame
        contentHeight = Int(fittingSize.height)
        
        tableView.reloadData()
        tableView.layoutIfNeeded()
    }
    
    @objc func goComments(){
        let index = IndexPath(row: 0, section: 2)
        
        if commentUserName.count != 0{
            
            self.tableView.scrollToRow(at: index, at: UITableView.ScrollPosition.top, animated: true)
            
        }else{
            
            let alert = UIAlertController(title: "Üzgünüz, bu gönderi için henüz bir yorum yapılmamış.", message: nil, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "İlk Yorumu Yap", style: .default, handler: {
                (alert: UIAlertAction!) in
                
                self.addComment()
                
            }))
            
            alert.addAction(UIAlertAction(title: "Kapat", style: .cancel, handler: {
                (alert: UIAlertAction!) in
                
            }))
            
            self.present(alert, animated: true)
            
        }
        
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
        let image = UIImage(named: "claps")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setTitle("Tarih", for: UIControl.State.normal)
        button.setImage(image, for: UIControl.State.normal)
        button.mixedTintColor = MixedColor(normal: UIColor.black, night: UIColor.white.withAlphaComponent(0.5))
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        button.setMixedTitleColor(MixedColor(normal: UIColor.black, night: UIColor.white.withAlphaComponent(0.5)), forState: UIControl.State.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let seperator: UIView = {
        let view = UIView()
        view.mixedBackgroundColor = MixedColor(normal: UIColor.lightGray, night: UIColor(hexString: "#3f4447"))
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
        let image = UIImage(named: "bookmarks")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(image, for: UIControl.State.normal)
        button.mixedTintColor = MixedColor(normal: UIColor.black, night: UIColor.white.withAlphaComponent(0.5))
        button.setTitle("Favorilere Ekle", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        button.setMixedTitleColor(MixedColor(normal: UIColor.black, night: UIColor.white.withAlphaComponent(0.5)), forState: UIControl.State.normal)
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
        let image = UIImage(named: "comments")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(image, for: UIControl.State.normal)
        button.mixedTintColor = MixedColor(normal: UIColor.black, night: UIColor.white.withAlphaComponent(0.5))
        button.setTitle("Yorumlar", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        button.setMixedTitleColor(MixedColor(normal: UIColor.black, night: UIColor.white.withAlphaComponent(0.5)), forState: UIControl.State.normal)
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
        let image = UIImage(named: "shareit")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(image, for: UIControl.State.normal)
        button.mixedTintColor = MixedColor(normal: UIColor.black, night: UIColor.white.withAlphaComponent(0.5))
        button.setTitle("Paylaş", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        button.setMixedTitleColor(MixedColor(normal: UIColor.black, night: UIColor.white.withAlphaComponent(0.5)), forState: UIControl.State.normal)
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
        mixedBackgroundColor = MixedColor(normal: UIColor.white, night: UIColor(hexString: "#282828"))
        
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
        seperator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
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
        
        mixedBackgroundColor = MixedColor(normal: UIColor.white, night: UIColor(hexString: "#282828"))
        
        addSubview(body)
        
        body.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        body.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        body.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        body.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        
        body.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: UIColor(hexString: "#282828"))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class CommentsCell: UITableViewCell {
    
    let avatar: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let avatarName: UILabel = {
        let button = UILabel()
        button.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.textAlignment = .left
        button.numberOfLines = 1
        button.mixedTextColor = MixedColor(normal: UIColor.black, night: UIColor.white.withAlphaComponent(0.8))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let body: UILabel = {
        let button = UILabel()
        button.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.textAlignment = .left
        button.numberOfLines = 0
        button.mixedTextColor = MixedColor(normal: UIColor.black, night: UIColor.white.withAlphaComponent(0.8))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        setupViews()
    }
    
    func setupViews(){
        
       mixedBackgroundColor = MixedColor(normal: UIColor.white, night: UIColor(hexString: "#282828"))
        
    }
    
    func addViews(){
        
        addSubview(avatar)
        
        avatar.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        avatar.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        avatar.heightAnchor.constraint(equalToConstant: 36).isActive = true
        avatar.widthAnchor.constraint(equalToConstant: 36).isActive = true
        
        avatar.layer.cornerRadius = 18
        avatar.clipsToBounds = true
        
        addSubview(avatarName)
        
        avatarName.leftAnchor.constraint(equalTo: avatar.rightAnchor, constant: 10).isActive = true
        avatarName.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        avatarName.heightAnchor.constraint(equalToConstant: 36).isActive = true
        avatarName.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 86).isActive = true
        
        addSubview(body)
        
        body.leftAnchor.constraint(equalTo: leftAnchor, constant: 66).isActive = true
        body.topAnchor.constraint(equalTo: avatarName.bottomAnchor).isActive = true
        body.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 86).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
