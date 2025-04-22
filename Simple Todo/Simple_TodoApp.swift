//
//  Simple_TodoApp.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 29/06/23.
//

import SwiftUI
import MenuBarExtraAccess

extension EnvironmentValues {
    @Entry var screenHeight: CGFloat = 0
}

enum MenuType {
    case main
    case pasteboard
}

@main
struct Simple_TodoApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate: AppDelegate
    private let taskDelegate = TaskDelegate.instance
    private let notificationController = NotificationController.instance
    private let preferenceController = PreferenceController.instance
    private let jiraController = JiraController.instance
    private let backgroundTaskScheduler = BackgroundTaskController.instance
    
    @State var isMenuPresented = false
    @State var statusItem: NSStatusItem? = nil
    @State var menuType: MenuType = .main
    
    init() {
    }
    
    var body: some Scene {
        let screenHeight = NSScreen.screens.first?.frame.height ?? 0
        return MenuBarExtra(content: {
            VStack {
                if menuType == .main {
                    MainMenuView()
                }  else {
                    PasteboardMenuView()
                        .onDisappear {
                            withAnimation {
                                menuType = .main
                            }
                        }
                }
            }
            
            .frame(width: 500, alignment: .topLeading)
            .onAppear{
                taskDelegate.loadTasks()
                notificationController.checkNotificationPermission()
                preferenceController.reload()
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
                    if item == seeMoreConstant {
                        openStatusItemMenu()
                        appDelegate.pasteboard.prepareForNewContents()
                        return
                    }
                    preferenceController.addToPasteboards(item)
                })
                .environmentObject(taskDelegate)
                .environmentObject(backgroundTaskScheduler)
                .environmentObject(preferenceController)
        })
        .menuBarExtraStyle(.window)
        .menuBarExtraAccess(isPresented: $isMenuPresented) { statusItem in // <-- the magic ✨
            self.statusItem = statusItem
        }
        .defaultSize(width: 500, height: screenHeight - screenHeight/4)
    }
    
    func openStatusItemMenu() {
        print(">>> See more")
        withAnimation {
            menuType = .pasteboard
            isMenuPresented = true
        }
    }
}
