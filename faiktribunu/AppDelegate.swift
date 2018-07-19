//
//  AppDelegate.swift
//  Faiktribunu
//
//  Created by Halil İbrahim YÜCE on 26.06.2018.
//  Copyright © 2018 Halil İbrahim YÜCE. All rights reserved.
//

import UIKit
import ScrollableSegmentedControl

let mAppDelegate = UIApplication.shared.delegate! as! AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var mNavigationController: UINavigationController?
    var mSplashViewController: SplashViewController?
    var mCustomTabBarController: CustomTabBarController?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UINavigationBar.appearance().barTintColor = UIColor.black
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        // Sets shadow (line below the bar) to a blank image
        UINavigationBar.appearance().shadowImage = UIImage()
        // Sets the translucent background color
        UINavigationBar.appearance().backgroundColor = .black
        // Set translucent. (Default value is already true, so this can be removed if desired.)
        UINavigationBar.appearance().isTranslucent = false
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        //UITabBar.appearance().tintColor = UIColor.white
        //UITabBar.appearance().backgroundColor = UIColor.black
        
        let tabBar = UITabBar.appearance()
        tabBar.tintColor = UIColor.red
        tabBar.backgroundColor = UIColor.white
        tabBar.unselectedItemTintColor = UIColor.gray
        
        
        
        let segmentedControlAppearance = ScrollableSegmentedControl.appearance()
        segmentedControlAppearance.segmentContentColor = UIColor.gray
        segmentedControlAppearance.selectedSegmentContentColor = UIColor.white
        segmentedControlAppearance.backgroundColor = UIColor.black
        segmentedControlAppearance.tintColor = UIColor.red
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        self.initialSlideNavigationController()
        
        self.window!.rootViewController = mNavigationController
        
        self.window!.makeKeyAndVisible()
        
        self.addSplashPage()
        
        return true
    }
    
    func initialSlideNavigationController() {
        
        mCustomTabBarController = CustomTabBarController(nibName:"CustomTabBarController",bundle:nil)
        //mLeftMenuViewController = LeftMenuViewController(nibName:"LeftMenuViewController",bundle:nil)
        
        mNavigationController = UINavigationController(rootViewController: mCustomTabBarController!)
        
    }
    
    func addSplashPage() {
        
        mSplashViewController = SplashViewController(nibName: "SplashViewController", bundle: nil)
        mSplashViewController!.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.window!.rootViewController!.view.addSubview(mSplashViewController!.view)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            let options: UIView.AnimationOptions = [.allowUserInteraction, .curveEaseInOut]
            UIView.transition(with: self.window!, duration: 0.50, options: options, animations: {() in
                
                UIView.animate(withDuration: 0.75, animations: { () -> Void in
                    UIView.setAnimationCurve(UIView.AnimationCurve.easeInOut)
                    
                    self.mCustomTabBarController = CustomTabBarController(nibName: "CustomTabBarController",bundle:nil)
                    
                    
                    self.mSplashViewController?.navigationController?.pushViewController(self.mCustomTabBarController!, animated: true)
                    
                    
                })
                
                self.mSplashViewController!.view!.layer.opacity = 0;
                self.mSplashViewController!.view!.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5);
                
            }, completion: {(finished: Bool) in
                
                self.mSplashViewController!.view.removeFromSuperview()
            })
        })
       
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

