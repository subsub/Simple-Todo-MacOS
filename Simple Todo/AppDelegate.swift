//
//  AppDelegate.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 30/06/23.
//

import Foundation
import AppKit
import UserNotifications

class AppDelegate: NSObject, NSApplicationDelegate, UNUserNotificationCenterDelegate {
    
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
    }
    
    // receive notification when app is in background
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        NSLog(">> did receive notification on background \(response.notification)")
        handleNotification(response.notification)
    }
    
    // receive notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        NSLog(">> did receive notification on foreground \(notification)")
        handleNotification(notification)
        return .sound
    }
    
    private func handleNotification(_ notification: UNNotification) {
        let notifName = Notification.Name(notifCenterName)
        NotificationCenter.default.post(name: notifName, object: notification.request.content)
    }
}
