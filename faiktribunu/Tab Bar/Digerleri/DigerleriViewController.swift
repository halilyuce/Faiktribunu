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

class DigerleriViewController: QuickTableViewController {

    override func viewWillAppear(_ animated: Bool) {
        self.setNavBarItems()
    }
    @IBOutlet var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        mAppDelegate.mNavigationController?.setNavigationBarHidden(true, animated: false)

        let paylas = #imageLiteral(resourceName: "paylas")
        let labters = #imageLiteral(resourceName: "labters")
        let faik = #imageLiteral(resourceName: "faikdiger")
        let bildirimler = #imageLiteral(resourceName: "bildirimler")
        let sozlesme = #imageLiteral(resourceName: "sozlesme")
        
        tableContents = [
            Section(title: "KİŞİSEL AYARLAR", rows: [
                SwitchRow(title: "Bildirimler", switchValue: true, icon: .image(bildirimler), action: didToggleSwitch()),
                ]),
            
            Section(title: "HAKKINDA", rows: [
                NavigationRow(title: "Uygulamayı Paylaş", subtitle: .none, icon: .image(paylas), action: showShare()),
                NavigationRow(title: "Gizlilik Sözleşmesi", subtitle: .rightAligned("Oku"), icon: .image(sozlesme), action: showDetail()),
                NavigationRow(title: "Yapım : Labters.com", subtitle: .none, icon: .image(labters), action: showLabters()),
                NavigationRow(title: "Uygulama Hakkında", subtitle: .none, icon: .image(faik)),
                NavigationRow(title: "v 1.0", subtitle: .leftAligned("sürümünü kullanıyorsunuz."))
                ], footer: "Uygulamamızı daha iyi hale getirmek için güncellemeler yayınlayacağız, lütfen güncellemeleri yapmaktan çekinmeyiniz 🤗"),
 
        ]
        
    }


    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        // Alter the cells created by QuickTableViewController
        return cell
    }
    
    // MARK: - Private Methods
    private func didToggleSelection() -> (Row) -> Void {
        return { [weak self] in
            if let option = $0 as? OptionRowCompatible {
                let state = "\(option.title) is " + (option.isSelected ? "selected" : "deselected")
                self?.showDebuggingText(state)
            }
        }
    }
    
    private func didToggleSwitch() -> (Row) -> Void {
        return { [weak self] in
            if let row = $0 as? SwitchRowCompatible {
                let state = "\(row.title) = \(row.switchValue)"
                self?.showDebuggingText(state)
            }
        }
    }
    
    private func showAlert() -> (Row) -> Void {
        return { [weak self] _ in
            let alert = UIAlertController(title: "Action Triggered", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel) { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    private func showDetail() -> (Row) -> Void {
        return { [weak self] in
            let detail = $0.title + ($0.subtitle?.text ?? "")
            let controller = UIViewController()
            controller.view.backgroundColor = .white
            controller.title = detail
            self?.navigationController?.pushViewController(controller, animated: true)
            self?.showDebuggingText(detail + " is selected")
        }
    }
    
    private func showShare() -> (Row) -> Void {
        return {_ in
        let string: String = "Faiktribünü mobil uygulamasını çok beğendim, haydi sen de yükle! :)"
        let URL: String = "http://www.faiktribunu.com"
        
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
