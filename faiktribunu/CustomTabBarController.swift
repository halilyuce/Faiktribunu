//
//  CustomTabBarController.swift
//  faiktribunu
//
//  Created by Mac on 18.07.2018.
//  Copyright © 2018 Halil İbrahim YÜCE. All rights reserved.
//

import UIKit
import AVKit
import Crashlytics
import NightNight

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        let feedController = ViewController()
        let navigationController = UINavigationController(rootViewController: feedController)
        navigationController.title = "Yazılar"
        navigationController.tabBarItem.image = UIImage(named: "news")
        navigationController.tabBarItem.tag = 0
        
        let fiksturController = FiksturViewController()
        let fiksturnavigationController = UINavigationController(rootViewController: fiksturController)
        fiksturnavigationController.title = "Puan & Fikstür"
        fiksturnavigationController.tabBarItem.image = UIImage(named: "puan")
        fiksturnavigationController.tabBarItem.tag = 1
        
        let favoriteController = FiksturViewController()
        let favoritenavigationController = UINavigationController(rootViewController: favoriteController)
        favoritenavigationController.title = "Favoriler"
        favoritenavigationController.tabBarItem.image = UIImage(named: "fav")
        favoritenavigationController.tabBarItem.tag = 2
        
        let bildirimController = BildirimViewController()
        let bildirimnavigationController = UINavigationController(rootViewController: bildirimController)
        bildirimnavigationController.title = "Bildirimler"
        bildirimnavigationController.tabBarItem.image = UIImage(named: "ring")
        bildirimnavigationController.tabBarItem.tag = 3
        
        let digerController = DigerleriViewController()
        let digernavigationController = UINavigationController(rootViewController: digerController)
        digernavigationController.title = "Ayarlar"
        digernavigationController.tabBarItem.image = UIImage(named: "settings")
        digernavigationController.tabBarItem.tag = 4
        
        viewControllers = [navigationController, favoritenavigationController, fiksturnavigationController, bildirimnavigationController, digernavigationController]
        
        
        let tabBar = UITabBar.appearance()
        tabBar.mixedTintColor = MixedColor(normal: UIColor.red, night: UIColor.red)
        tabBar.isTranslucent = true
        tabBar.mixedBarTintColor = MixedColor(normal: UIColor.white.withAlphaComponent(0.2), night: UIColor.black.withAlphaComponent(0.2))
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        Answers.logCustomEvent(withName: "Tablar",
                               customAttributes: [
                                "Tıklama": "\(tabBar.selectedItem!.title!)",
                                ])
    
    }
    
    
    var kontrol = 0
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        kontrol = kontrol + 1
        
        
        switch tabBarController.tabBar.tag {
        case 0:
      
            if kontrol%2 == 0{
                guard let viewControllers = viewControllers else { return false }
                if viewController == viewControllers[0] {
                    if let nav = viewController as? UINavigationController {
                        if let vc = nav.viewControllers.last as? ViewController{
                            let childs = vc.children
                            
                            for child in childs{
                                if let yazilar = child as? YazilarViewController{
                                    yazilar.mCollectionView.setContentOffset(.zero, animated: true)
                                }
                            }
                        }
                        return true
                    }
                }
            }
            
        default:
            kontrol = 0
            break
        }
        return true
    }

}
