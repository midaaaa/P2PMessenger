//
//  AppNotificationDelegate.swift
//  P2PMessenger
//
//  Created by Maksim on 03.04.2026.
//

import UIKit
import UserNotifications

final class AppNotificationDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var container: RootGraph?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, 
                                willPresent notification: UNNotification, 
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        guard let container else {
            completionHandler([.banner, .list, .sound])
            return
        }

        if let payload = NotificationPayload(userInfo: notification.request.content.userInfo),
           container.router.isAppActive,
           container.router.activeDestination == payload.destination {
            completionHandler([])
        } else {
            completionHandler([.banner, .list, .sound])
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, 
                                didReceive response: UNNotificationResponse, 
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo

        if let payload = NotificationPayload(userInfo: userInfo) {
            DispatchQueue.main.async {
                switch payload.destination {
                case .common:
                    self.container?.router.selectedTab = .commonChat
                case .private(let peerID):
                    self.container?.router.selectedTab = .chats
                    self.container?.router.activeChatId = peerID
                }
            }
        }
        
        completionHandler()
    }
}
