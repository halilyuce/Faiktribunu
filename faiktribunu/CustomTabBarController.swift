//
//  CustomTabBarController.swift
//  faiktribunu
//
//  Created by Mac on 18.07.2018.
//  Copyright © 2018 Halil İbrahim YÜCE. All rights reserved.
//

import UIKit
import AVKit

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
        
        let bildirimController = BJKTVViewController()
        let bildirimnavigationController = UINavigationController(rootViewController: bildirimController)
        bildirimnavigationController.title = "Bildirimler"
        bildirimnavigationController.tabBarItem.image = UIImage(named: "ring")
        bildirimnavigationController.tabBarItem.tag = 2
        
        let digerController = BJKTVViewController()
        let digernavigationController = UINavigationController(rootViewController: digerController)
        digernavigationController.title = "Diğerleri"
        digernavigationController.tabBarItem.image = UIImage(named: "bar")
        digernavigationController.tabBarItem.tag = 3
        
        viewControllers = [navigationController, fiksturnavigationController, bildirimnavigationController, digernavigationController]
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
