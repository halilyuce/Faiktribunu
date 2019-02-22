//
//  DigerleriViewController.swift
//  faiktribunu
//
//  Created by Mac on 22.07.2018.
//  Copyright © 2018 Halil İbrahim YÜCE. All rights reserved.
//

import UIKit
import QuickTableViewController
import SafariServices
import OneSignal
import NightNight

class DigerleriViewController: QuickTableViewController {

    override func viewWillAppear(_ animated: Bool) {
        self.setNavBarItems()
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
    @IBOutlet var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        mAppDelegate.mNavigationController?.setNavigationBarHidden(true, animated: false)
        
        tableView.mixedBackgroundColor = MixedColor(normal: UIColor.groupTableViewBackground, night: UIColor(hexString: "#282828"))
        tableView.mixedSeparatorColor = MixedColor(normal: UIColor.lightGray, night: UIColor(hexString: "#3f4447"))
        
        
        let paylas = Icon.init(image: UIImage(named: "paylas")!)
        let color = Icon.init(image: UIImage(named: "color")!)
        let labters = Icon.init(image: UIImage(named: "labters")!)
        let faik = Icon.init(image: UIImage(named: "faikdiger")!)
        let bildirimler = Icon.init(image: UIImage(named: "bildirimler")!)
        let sozlesme = Icon.init(image: UIImage(named: "sozlesme")!)
        
        UserDefaults.standard.register(defaults: ["bildirim" : true])
        let switches = UserDefaults.standard.bool(forKey: "bildirim")
        
        UserDefaults.standard.register(defaults: ["colormode" : false])
        let colorSwitches = UserDefaults.standard.bool(forKey: "colormode")
        
        tableContents = [
            Section(title: "KİŞİSEL AYARLAR", rows: [
                SwitchRow(title: "Bildirimler", switchValue: switches, icon: bildirimler, action: didToggleSwitch()),
                SwitchRow(title: "Karanlık Mod", switchValue: colorSwitches, icon: color, action: didColorSwitch())
                ]),
            
            Section(title: "HAKKINDA", rows: [
                NavigationRow(title: "Uygulamayı Paylaş", subtitle: .none, icon: paylas, action: showShare()),
                NavigationRow(title: "Gizlilik Sözleşmesi", subtitle: .rightAligned("Oku"), icon: sozlesme, action: showDetail()),
                NavigationRow(title: "Yapım : Labters.com", subtitle: .none, icon: labters, action: showLabters()),
                NavigationRow(title: "Uygulama Hakkında", subtitle: .none, icon: faik),
                NavigationRow(title: "v 2.0", subtitle: .leftAligned("sürümünü kullanıyorsunuz."))
                ], footer: "Uygulamamızı daha iyi hale getirmek için güncellemeler yayınlayacağız, lütfen güncellemeleri yapmaktan çekinmeyiniz 🤗"),
 
        ]
        
    }


    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        // Alter the cells created by QuickTableViewController
        cell.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: UIColor(hexString: "#171717"))
        cell.detailTextLabel?.mixedTextColor = MixedColor(normal: UIColor.black, night: UIColor.white)
        cell.textLabel?.mixedTextColor = MixedColor(normal: UIColor.black, night: UIColor.white)
        
        let backgroundView = UIView()
        backgroundView.mixedBackgroundColor = MixedColor(normal: UIColor.groupTableViewBackground, night: UIColor.black)
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    

    
    private func didToggleSwitch() -> (Row) -> Void {
        return { [weak self] in
            if let row = $0 as? SwitchRow {
                let state = "\(row.title) = \(row.switchValue)"
                self?.showDebuggingText(state)
                
                if row.switchValue == true{
                    OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification
                    UIApplication.shared.registerForRemoteNotifications()
                    print("Thanks for accepting notifications!")
                }else {
                    OneSignal.inFocusDisplayType = OSNotificationDisplayType.none
                    UIApplication.shared.unregisterForRemoteNotifications()
                    print("Notifications not accepted. You can turn them on later under your iOS settings.")
                }
                
                UserDefaults.standard.set(row.switchValue, forKey: "bildirim")
                
            }
            
        }
    }
    
    private func didColorSwitch() -> (Row) -> Void {
        return { [weak self] in
            if let row = $0 as? SwitchRow {
                let state = "\(row.title) = \(row.switchValue)"
                self?.showDebuggingText(state)
                
                if row.switchValue == true{
                    NightNight.theme = .night
                    
                    self?.tabBarController?.tabBar.barTintColor = UIColor.black.withAlphaComponent(0.2)
                    self?.tabBarController?.tabBar.tintColor = UIColor.red
                    
                }else {
                    NightNight.theme = .normal
                    self?.tabBarController?.tabBar.barTintColor = UIColor.white.withAlphaComponent(0.2)
                    self?.tabBarController?.tabBar.tintColor = UIColor.red
                }
                
                UserDefaults.standard.set(row.switchValue, forKey: "colormode")
                
            }
            
        }
    }
    
    
    private func showDetail() -> (Row) -> Void {
        return {_ in
            let controller = GizlilikViewController()
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    private func showShare() -> (Row) -> Void {
        return {_ in
        let string: String = "Faiktribünü mobil uygulamasını çok beğendim, haydi sen de yükle! :)"
        let URL: String = "https://itunes.apple.com/tr/app/faik-trib%C3%BCn%C3%BC/id1420791069?l=tr&mt=8"
        
        let activityViewController = UIActivityViewController(activityItems: [string, URL], applicationActivities: nil)
            self.navigationController?.present(activityViewController, animated: true) {
        }
    }
    }
    
    private func showLabters() -> (Row) -> Void {
        return {_ in
            let laburl = URL.init(string: "http://www.labters.com")
            let lvc = SFSafariViewController(url: laburl!)
            self.present(lvc, animated: true, completion: nil)
        }
    }
    
    private func showDebuggingText(_ text: String) {
        print(text)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.tableView.reloadData()
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
