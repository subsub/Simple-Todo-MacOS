//
//  NewTaskView.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 29/06/23.
//

import SwiftUI

struct NewTaskView: View {
    @EnvironmentObject var taskDelegate: TaskDelegate
    @EnvironmentObject var navigationState: MyNavigationState
    @EnvironmentObject var notificationController: NotificationController
    @EnvironmentObject var preferenceController: PreferenceController
    @EnvironmentObject var jiraController: JiraController
    @State var taskTitle: String = ""
    @State var isReminder: Bool = false
    @State var displayDate: Date = .now
    @State var selectedDate: Date? = nil
    @State var navbarTitle: String = "Create New Task"
    @State var taskId: String? = nil
    @State var jiraId: String = ""
    @State var isLoading: Bool = false
    @State var message: String = ""
    @State var shouldShowToast: Bool = false
    
    var body: some View {
        VStack {
            MyNavigationBar(title: navbarTitle, confirmText: "Save", confirmButtonEnabled: !taskTitle.isEmpty) {
                if isLoading {
                    return
                }
                navigationState.pop()
            } onConfirmButton: {
                
                let task = TaskModel(
                    title: taskTitle,
                    timestamp: "")
                
                if let taskId = taskId {
                    task.id = taskId
                }
                
                if !jiraId.isEmpty {
                    isLoading = true
                    jiraController.loadIssueDetail(by: jiraId) { jiraDetail in
                        isLoading = false
                        guard let detail = jiraDetail else {
                            message = "Issue not found: \(jiraId)"
                            withAnimation {
                                shouldShowToast = true
                            }
                            return
                        }
                        task.setJiraCard(jiraId)
                        task.jiraStatus = detail.status
                        save(task: task)
                    }
                } else {
                    isLoading = false
                    save(task: task)
                }
            }
            
            ZStack {
                VStack {
                    TextField("Task", text: $taskTitle)
                        .padding(defaultPadding)
                    
                    Divider()
                    
                    Toggle(isOn: $isReminder) {
                        HStack{
                            Text("Remind me")
                            Spacer()
                        }
                    }.toggleStyle(.switch)
                        .padding(defaultPadding)
                    
                    
                    reminderView
                        .padding(defaultPadding)
                    
                    if preferenceController.hasJiraAuthKey() {
                        Divider()
                        
                        jiraIntegrationView
                    }
                }
                
                if isLoading {
                    ProgressView()
                }
                
                MyToast(isShowing: $shouldShowToast, title: message, type: .Error)
                
            }
        }
        .onAppear{
            if let taskId = navigationState.data["id"] as? String, let task = taskDelegate.getTask(by: taskId) {
                navbarTitle = "Edit Task"
                taskTitle = task.title
                isReminder = !task.timestamp.isEmpty
                selectedDate = task.asDate()
                displayDate = task.asDate() ?? .now
                jiraId = task.jiraCard ?? ""
                self.taskId = task.id
            }
            
        }
    }
    
    func save(task: TaskModel) {
        if isReminder {
            selectedDate = displayDate
            task.timestamp = selectedDate?.ISO8601Format() ?? ""
            notificationController.scheduleNotificationFor(task: task)
        } else {
            notificationController.removeNotifications([task.id])
        }
        
        taskDelegate.saveTask(task)
        navigationState.pop()
    }
    
    var reminderView: some View {
        VStack {
            if isReminder {
                Divider()
                DatePicker(selection: $displayDate, label: {  })
                    .datePickerStyle(.graphical)
            }
            
        }
    }
    
    var jiraIntegrationView: some View {
        VStack {
            HStack {
                Text("Jira Card")
                TextField("Jira Card", text: $jiraId)
            }
        }
        .padding(defaultPadding)
    }
}

struct NewTaskView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskView()
            .environmentObject(TaskDelegate.instance)
            .environmentObject(MyNavigationState())
            .environmentObject(NotificationController.instance)
            .environmentObject(PreferenceController.instance)
    }
}
