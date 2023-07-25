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
    @EnvironmentObject var preferenceController: PreferenceController
    @State var keyObserver: NSKeyValueObservation?
    
    var body: some View {
        MyNavigationController {
            VStack {
                VStack {
                    ZStack {
                        // hidden navigation link for new-task
                        MyNavigationLink(id: "new-task", autoRedirect: false, expanded: false, padding: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)) {
                            EmptyView()
                        } destination: {
                            NewTaskView()
                        }
                        .frame(width:0, height: 0)
                        
                        NewTaskButton()
                    }
                    
                    Divider()
                    
                    if preferenceController.hasJiraAuthKey() {
                        IssueTrackerButton()
                        
                        Divider()
                    }
                }
                
                VStack {
                    
                    TaskList()
                    
                    Divider()
                    
                    DeleteAllDoneButton()
                    
                    ClearButton()
                    
                    Divider()
                }
                
                VStack {
                    
                    PreferenceButton()
                    
                    Divider()
                    
                    QuitButton()
                    
                }
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
            .environmentObject(PreferenceController.instance)
    }
}
