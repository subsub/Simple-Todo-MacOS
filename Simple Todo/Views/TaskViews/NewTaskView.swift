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
    @State var taskTitle: String = ""
    @State var isReminder: Bool = false
    @State var displayDate: Date = .now
    @State var selectedDate: Date? = nil
    @State var navbarTitle: String = "Create New Task"
    @State var taskId: String? = nil
    @State var jiraId: String = ""
    
    var body: some View {
        VStack {
            MyNavigationBar(title: navbarTitle, confirmText: "Save", confirmButtonEnabled: !taskTitle.isEmpty) {
                navigationState.popTo(id: nil)
            } onConfirmButton: {
                let task = TaskModel(
                    title: taskTitle,
                    timestamp: "")
                if let taskId = taskId {
                    task.id = taskId
                }
                if !jiraId.isEmpty {
                    task.setJiraCard(jiraId)
                }
                
                if isReminder {
                    selectedDate = displayDate
                    task.timestamp = selectedDate?.ISO8601Format() ?? ""
                    notificationController.scheduleNotificationFor(task: task)
                } else {
                    notificationController.removeNotifications([task.id])
                }
                
                taskDelegate.saveTask(task)
                navigationState.popTo(id: nil)
            }
            
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
        HStack {
            Text("Jira Card")
            TextField("Jira Card", text: $jiraId)
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
