//
//  Simple_TodoApp.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 29/06/23.
//

import SwiftUI

let defaultPadding: EdgeInsets = EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
let smallPadding: EdgeInsets = EdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4)

@main
struct Simple_TodoApp: App {
//    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate: AppDelegate
    private let userDefaultDelegates = UserDefaultsDelegates.instance
    private let notificationController = NotificationController.instance
    
    
    var body: some Scene {
        return MenuBarExtra(content: {
            MainMenuView()
                .onAppear{
                    notificationController.checkNotificationPermission()
                }
                .environmentObject(userDefaultDelegates)
                .environmentObject(notificationController)
        }, label: {
            StatusMenuView()
                .onReceive(notifCenterPublisher){ output in
                    userDefaultDelegates.loadTasks()
                }
                .environmentObject(userDefaultDelegates)
        })
        .menuBarExtraStyle(.window)
    }
}
