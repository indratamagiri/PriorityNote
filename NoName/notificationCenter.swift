//
//  notificationCenter.swift
//  NoName
//
//  Created by giri on 6/19/18.
//  Copyright © 2018 Bianka. All rights reserved.
//

import Foundation
import UserNotifications


class UYLNotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Play sound and show alert to the user\
        print(notification.request.content.categoryIdentifier)
        completionHandler([.alert,.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        // Determine the user action
        print(response.notification.request.content.categoryIdentifier)
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            print("Default")
        case "Done":
            print("Snooze")
        case "Belum":
            print("Delete")
        default:
            print("Unknown action")
        }
        completionHandler()
    }
}


