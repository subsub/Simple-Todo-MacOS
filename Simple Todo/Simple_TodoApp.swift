//
//  Simple_TodoApp.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 29/06/23.
//

import SwiftUI

extension EnvironmentValues {
    @Entry var screenHeight: CGFloat = 0
}

@main
struct Simple_TodoApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate: AppDelegate
    private let taskDelegate = TaskDelegate.instance
    private let notificationController = NotificationController.instance
    private let preferenceController = PreferenceController.instance
    private let jiraController = JiraController.instance
    private let backgroundTaskScheduler = BackgroundTaskController.instance
    
    
    var body: some Scene {
        let screenHeight = NSScreen.screens.first?.frame.height ?? 0
        return MenuBarExtra(content: {
            MainMenuView()
                .frame(width: 500, alignment: .topLeading)
                .onAppear{
                    taskDelegate.loadTasks()
                    notificationController.checkNotificationPermission()
                }
                .environmentObject(taskDelegate)
                .environmentObject(notificationController)
                .environmentObject(preferenceController)
                .environmentObject(jiraController)
                .environmentObject(appDelegate)
                .environment(\.screenHeight, screenHeight)
        }, label: {
            StatusMenuView()
                .onAppear {
                    backgroundTaskScheduler.scheduleRefresh()
                }
                .onReceive(notifCenterPublisher){ output in
                    taskDelegate.loadTasks()
                }
                .onReceive(pasteboardPublisher, perform: { output in
                    guard let pb = output.object as? NSPasteboard else { return }
                    guard let items = pb.pasteboardItems else { return }
                    guard let item = items.first?.string(forType: .string) else { return } // you should handle multiple types
                    preferenceController.addToPasteboards(item)
                })
                .environmentObject(taskDelegate)
                .environmentObject(backgroundTaskScheduler)
                .environmentObject(preferenceController)
        })
        .menuBarExtraStyle(.window)
        .defaultSize(width: 500, height: screenHeight - screenHeight/4)
    }
}
