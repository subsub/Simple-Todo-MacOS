//
//  MainMenuView.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 29/06/23.
//

import SwiftUI

struct MainMenuView: View {
    @EnvironmentObject var taskDelegate: TaskDelegate
    @EnvironmentObject var notificationController: NotificationController
    @State var keyObserver: NSKeyValueObservation?
    
    var body: some View {
        MyNavigationController {
            VStack {
                NewTaskButton()
                
                Divider()
                
                TaskList()
                
                Divider()
                
                DeleteAllDoneButton()
                
                ClearButton()
                
                Divider()
                
                PreferenceButton()
                
                Divider()
                
                QuitButton()
            }
        }
        .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
        .onAppear {
            keyObserver = NSApplication.shared.observe(\.keyWindow) { x, y in
                print("Is Visible: \(NSApplication.shared.keyWindow != nil)")
                if (NSApplication.shared.keyWindow != nil) {
                    taskDelegate.loadTasks()
                }
            }
        }
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
            .environmentObject(TaskDelegate.instance)
    }
}
