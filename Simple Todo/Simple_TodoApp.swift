//
//  Simple_TodoApp.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 29/06/23.
//

import SwiftUI

let defaultPadding: EdgeInsets = EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
let smallPadding: EdgeInsets = EdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4)
let symmetricPadding: EdgeInsets = EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

@main
struct Simple_TodoApp: App {
//    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate: AppDelegate
    private let taskDelegate = TaskDelegate.instance
    private let notificationController = NotificationController.instance
    private let preferenceController = PreferenceController.instance
    private let jiraController = JiraController.instance
    private let backgroundTaskScheduler = BackgroundTaskController.instance
    
    
    var body: some Scene {
        return MenuBarExtra(content: {
            MainMenuView()
                .frame(maxHeight: .infinity, alignment: .topLeading)
                .onAppear{
                    taskDelegate.loadTasks()
                    notificationController.checkNotificationPermission()
                }
                .environmentObject(taskDelegate)
                .environmentObject(notificationController)
                .environmentObject(preferenceController)
                .environmentObject(jiraController)
        }, label: {
            StatusMenuView()
                .onAppear {
                    backgroundTaskScheduler.scheduleRefresh()
                }
                .onReceive(notifCenterPublisher){ output in
                    taskDelegate.loadTasks()
                }
                .environmentObject(taskDelegate)
                .environmentObject(backgroundTaskScheduler)
        })
        .menuBarExtraStyle(.window)
    }
}
