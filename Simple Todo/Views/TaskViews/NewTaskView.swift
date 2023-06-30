//
//  NewTaskView.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 29/06/23.
//

import SwiftUI

struct NewTaskView: View {
    @EnvironmentObject var taskDelegate: UserDefaultsDelegates
    @EnvironmentObject var navigationState: MyNavigationState
    @EnvironmentObject var notificationController: NotificationController
    @State var taskTitle: String = ""
    @State var isReminder: Bool = false
    @State var displayDate: Date = .now
    @State var selectedDate: Date? = nil
    @State var navbarTitle: String = "Create New Task"
    @State var taskId: String? = nil
    
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
                
                if isReminder {
                    selectedDate = displayDate
                    task.timestamp = selectedDate?.ISO8601Format() ?? ""
                    notificationController.scheduleNotificationFor(task: task)
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
        }
        .onAppear{
            if let taskId = navigationState.data["id"] as? String, let task = taskDelegate.getTask(by: taskId) {
                navbarTitle = "Edit Task"
                taskTitle = task.title
                isReminder = !task.timestamp.isEmpty
                selectedDate = task.asDate()
                displayDate = task.asDate() ?? .now
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
}

struct NewTaskView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskView()
    }
}
