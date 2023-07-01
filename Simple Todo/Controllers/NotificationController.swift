//
//  NotificationController.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 30/06/23.
//

import UserNotifications
import SwiftUI
import Foundation

let notifCenterName = "id.subkhansarif.Simple-Todo"
let notifCenterPublisher = NotificationCenter.default.publisher(for: Notification.Name(notifCenterName))

class NotificationController :NSObject, ObservableObject {
    static let instance = NotificationController()
    
    private let notificationCenter = UNUserNotificationCenter.current()
    let backgroundTaskScheduler = BackgroundTaskController.instance
    
    @Published var isDenied: Bool = false
    @Published var isAuthorized: Bool = false
    
    override init() {
        super.init()
        notificationCenter.delegate = self
    }
    
    func checkNotificationPermission() -> Void {
        notificationCenter.getNotificationSettings { [weak self] settings in
            if settings.authorizationStatus == .denied {
                self?.isDenied = true
                return
            }

            if settings.authorizationStatus != .authorized {
                self?.notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] success, error in
                    self?.isAuthorized = success
                    if success {
                        print(">> notification is set")
                        self?.notificationCenter.delegate = self
                    } else if let error = error {
                        print(">> notification request error: \(error.localizedDescription)")
                    }
                }
            } else {
                self?.notificationCenter.delegate = self
            }
        }
        
    }
    
    func scheduleNotificationFor(task: TaskModel) {
        guard let date = task.asDate() else {
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = task.title
        content.subtitle = task.formattedDate()
        content.sound = UNNotificationSound.default
        content.targetContentIdentifier = task.id
        
        let calendar = Calendar.current
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date),
            repeats: false)
        
        let request = UNNotificationRequest(identifier: notifCenterName, content: content, trigger: trigger)
        
        notificationCenter.add(request)
        
        // schedule background task
        backgroundTaskScheduler.schedule(at: date, for: task.id) {
            print(">> done scheduled")
        }
    }
    
    func removeNotifications(_ ids: [String]) {
        notificationCenter.removeDeliveredNotifications(withIdentifiers: ids)
        notificationCenter.removePendingNotificationRequests(withIdentifiers: ids)
    }
}

extension NotificationController: UNUserNotificationCenterDelegate {
    
    // receive notification when app is in background
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(">> did receive notification on background \(response.notification)")
        handleNotification(response.notification)
        completionHandler()
    }
    
    // receive notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print(">> did receive notification on foreground \(notification)")
        handleNotification(notification)
        completionHandler(.sound)
    }
    
    private func handleNotification(_ notification: UNNotification) {
        let notifName = Notification.Name(notifCenterName)
        NotificationCenter.default.post(name: notifName, object: notification.request.content)
    }
}
