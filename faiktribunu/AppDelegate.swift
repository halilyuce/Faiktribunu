//
//  AppDelegate.swift
//  Faiktribunu
//
//  Created by Halil İbrahim YÜCE on 26.06.2018.
//  Copyright © 2018 Halil İbrahim YÜCE. All rights reserved.
//

import UIKit
import ScrollableSegmentedControl
import OneSignal
import UserNotifications
import CoreData

let mAppDelegate = UIApplication.shared.delegate! as! AppDelegate


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, OSPermissionObserver, OSSubscriptionObserver  {
    
    var yazinumara = String()
    var videoLink = String()
    var format = String()
    var currentDateTime = Date()
    var bildirimPostID = String()
    var bildirimPostDate = String()
    var bildirimPostBody = String()
    var bildirimPostTitle = String()
    var bildirimPostFormat = String()
    var bildirimPostVideoUrl = String()
    var bildirimPostResimUrl = String()
    var window: UIWindow?
    var mNavigationController: UINavigationController?
    var mSplashViewController: SplashViewController?
    var mCustomTabBarController: CustomTabBarController?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
    
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        
        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "4a354947-9d3d-4f0d-99cf-1f3694593804",
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        
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
        tabBar.tintColor =  UIColor(red: 255.0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        tabBar.isTranslucent = true
        tabBar.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.1)
        tabBar.unselectedItemTintColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.4)
        
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
        
        // Add your AppDelegate as an obsserver
        OneSignal.add(self as OSPermissionObserver)
        
        OneSignal.add(self as OSSubscriptionObserver)
        
        registerForPushNotifications()
        
        return true
    }
    
     /* func deleteAllRecords() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Bildirimler")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    } */
    
    func initialSlideNavigationController() {
        
        mCustomTabBarController = CustomTabBarController(nibName:"CustomTabBarController",bundle:nil)
        
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
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "faiktribunu")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    
    func onOSPermissionChanged(_ stateChanges: OSPermissionStateChanges!) {
        
        // Example of detecting answering the permission prompt
        if stateChanges.from.status == OSNotificationPermission.notDetermined {
            if stateChanges.to.status == OSNotificationPermission.authorized {
                print("Thanks for accepting notifications!")
            } else if stateChanges.to.status == OSNotificationPermission.denied {
                print("Notifications not accepted. You can turn them on later under your iOS settings.")
            }
        }
        // prints out all properties
        print("PermissionStateChanges: \n\(stateChanges)")
    }
    
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!) {
        if !stateChanges.from.subscribed && stateChanges.to.subscribed {
            print("Subscribed for OneSignal push notifications!")
        }
        print("SubscriptionStateChange: \n\(stateChanges)")
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            // 1. Check if permission granted
            guard granted else { return }
            // 2. Attempt registration for remote notifications on the main thread
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // 1. Convert device token to string
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        // 2. Print device token to use for PNs payloads
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // 1. Print out error if PNs registration not successful
        print("Failed to register for remote notifications with error: \(error)")
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
    
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print(response.notification.request.content.title)
        print(response.notification.request.content.body)
        
        bildirimPostTitle = response.notification.request.content.title
        bildirimPostBody = response.notification.request.content.body
        
        var postId = ""
        
        if let custom = response.notification.request.content.userInfo["custom"] as? NSDictionary{
            if let a = custom["a"] as? NSDictionary{
                if let id = a["post"] as? String{
                    postId = id
                }
            }
        }
        
        var postformat = ""
        
        if let customformat = response.notification.request.content.userInfo["custom"] as? NSDictionary{
            if let a = customformat["a"] as? NSDictionary{
                if let type = a["format"] as? String{
                    postformat = type
                }
            }
        }
        
        var resimUrl = ""
        
        if let att = response.notification.request.content.userInfo["att"] as? NSDictionary{
            if let url = att["id"] as? String{
                resimUrl = url
            }
        }
        
        var videoUrl = ""
        
        if let customvideo = response.notification.request.content.userInfo["custom"] as? NSDictionary{
            if let a = customvideo["a"] as? NSDictionary{
                if let vidurl = a["video"] as? String{
                    videoUrl = vidurl
                }
            }
        }
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: date)
        let yourDate: Date? = formatter.date(from: myString)
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let updatedString = formatter.string(from: yourDate!)

        bildirimPostID = postId
        bildirimPostFormat = postformat
        bildirimPostVideoUrl = videoUrl
        bildirimPostResimUrl = resimUrl
        bildirimPostDate = updatedString
        
        
        let context = mAppDelegate.persistentContainer.viewContext
        let yeniBildirim = NSEntityDescription.insertNewObject(forEntityName: "Bildirimler", into: context)
        
        
        
        yeniBildirim.setValue(bildirimPostID, forKey: "postID")
        yeniBildirim.setValue(bildirimPostBody, forKey: "postBody")
        yeniBildirim.setValue(bildirimPostTitle, forKey: "postTitle")
        yeniBildirim.setValue(bildirimPostFormat, forKey: "postFormat")
        yeniBildirim.setValue(bildirimPostVideoUrl, forKey: "postVideoUrl")
        yeniBildirim.setValue(bildirimPostResimUrl, forKey: "postResimUrl")
        yeniBildirim.setValue(bildirimPostDate, forKey: "update")
        
        do {
            try context.save()
            print("kaydedildi")
        } catch {
            print("Failed saving")
        }
        
        print(postId)
        print(postformat)
        print(videoUrl)
        
        if response.actionIdentifier == "oku" {
            
            //self.mNavigationController?.setNavigationBarHidden(false, animated: false)
            var nav = UINavigationController()
            if let vc = mAppDelegate.mNavigationController?.topViewController as? UIViewController{
                nav = vc.navigationController!
            }
            self.yazinumara = postId
            self.videoLink = videoUrl
            self.format = postformat
            let selectedItem = yazinumara
            let videoItem = videoLink
            let formatItem = format
            
            let mDetayViewController = DetayViewController(nibName: "DetayViewController", bundle: nil)
            mDetayViewController.yaziNumara = selectedItem
            mDetayViewController.yaziFormat = formatItem
            mDetayViewController.videoLink = videoItem
            mDetayViewController.showBackButton = true
            
            let newNavController = UINavigationController.init(rootViewController: mDetayViewController)
            if Int(postId) != nil{
             nav.present(newNavController, animated: true, completion: {})
            }
            
            
                   } else if response.actionIdentifier == "kapat" {
            print("KAPAT")
                    } else {
            
            self.yazinumara = postId
            self.videoLink = videoUrl
            self.format = postformat
            let selectedItem = yazinumara
            let videoItem = videoLink
            let formatItem = format
            
            var nav = UINavigationController()
            if let vc = mAppDelegate.mNavigationController?.topViewController as? UIViewController{
                nav = vc.navigationController!
            }
           
            
            let mDetayViewController = DetayViewController(nibName: "DetayViewController", bundle: nil)
            mDetayViewController.yaziNumara = selectedItem
            mDetayViewController.yaziFormat = formatItem
            mDetayViewController.videoLink = videoItem
            
             mDetayViewController.showBackButton = true
            let newNavController = UINavigationController.init(rootViewController: mDetayViewController)
            if Int(postId) != nil{
                nav.present(newNavController, animated: true, completion: {})
            }
            
            
            }
        
        completionHandler()
    }

}
