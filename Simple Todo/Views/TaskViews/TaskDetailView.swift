//
//  TaskDetailView.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 30/06/23.
//

import SwiftUI

struct TaskDetailView: View {
    @EnvironmentObject var navigationState: MyNavigationState
    @EnvironmentObject var taskDelegate: UserDefaultsDelegates
    var id: String
    var task: TaskModel
    
    var body: some View {
        VStack {
            MyNavigationBar(title: "Detail", confirmText: "Edit") {
                navigationState.popTo(id: nil)
            } onConfirmButton: {
                navigationState.push(id: "new-task", data: ["id": task.id])
            }
            
            taskDetail
            
            HStack {
                Button {
                    taskDelegate.delete(task: task)
                    navigationState.popTo(id: nil)
                } label: {
                    Text("Delete")
                }
                .foregroundColor(.red)
                .buttonStyle(.plain)
            }
        }
        .frame(minWidth: 500)
        .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
    }
    
    var taskDetail: some View {
        Table([task]) {
            TableColumn("Title", value: \.title)
            TableColumn("Due At") { t in
                Text(t.formattedDate())
            }
            TableColumn("Status") { t in
                Text(String(describing: t.status))
                    .padding(.trailing)
            }
        }
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let task = TaskModel(title: "Some teng", timestamp: "")
        let date = Date.now
        task.timestamp = date.ISO8601Format()
        return TaskDetailView(id: task.id, task: task)
    }
}
