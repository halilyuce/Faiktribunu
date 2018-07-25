//
//  NotificationService.swift
//  OneSignalNotificationServiceExtension
//
//  Created by Mac on 23.07.2018.
//  Copyright © 2018 Halil İbrahim YÜCE. All rights reserved.
//

import UserNotifications

import OneSignal

class NotificationService: UNNotificationServiceExtension {
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var receivedRequest: UNNotificationRequest!
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.receivedRequest = request;
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            OneSignal.didReceiveNotificationExtensionRequest(self.receivedRequest, with: self.bestAttemptContent)
            contentHandler(bestAttemptContent)
        }
        
        // Add action.
        let stopAction = UNNotificationAction(identifier: "oku", title: "Yazıyı Oku", options: [.foreground])
        let snoozeAction = UNNotificationAction(identifier: "kapat", title: "Kapat", options: [])
        
        // Create category.
        let category = UNNotificationCategory(identifier: "etkilesim", actions: [stopAction, snoozeAction], intentIdentifiers: [], options: [])
        
        
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            OneSignal.serviceExtensionTimeWillExpireRequest(self.receivedRequest, with: self.bestAttemptContent)
            contentHandler(bestAttemptContent)
        }
    }
    
}
