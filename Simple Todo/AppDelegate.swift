//
//  AppDelegate.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 30/06/23.
//

import Foundation
import AppKit
import UserNotifications


class AppDelegate: NSObject, NSApplicationDelegate, UNUserNotificationCenterDelegate, ObservableObject {
    var timer: Timer!
    let pasteboard: NSPasteboard = .general
    var lastChangeCount: Int = 0
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (t) in
                    if self.lastChangeCount != self.pasteboard.changeCount {
                        self.lastChangeCount = self.pasteboard.changeCount
                        NotificationCenter.default.post(name: .NSPasteboardDidChange, object: self.pasteboard)
                    }
                }
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        timer.invalidate()
    }
    
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
