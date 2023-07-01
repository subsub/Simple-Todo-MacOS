//
//  TaskDetailView.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 30/06/23.
//

import SwiftUI

struct TaskDetailView: View {
    @EnvironmentObject var navigationState: MyNavigationState
    @EnvironmentObject var taskDelegate: TaskDelegate
    @EnvironmentObject var preferenceController: PreferenceController
    @EnvironmentObject var jiraController: JiraController
    var id: String
    var task: TaskModel
    @State var jiraCardDetail: JiraCardDetail? = nil
    
    var body: some View {
        VStack {
            MyNavigationBar(title: "Detail", confirmText: "Edit") {
                navigationState.popTo(id: nil)
            } onConfirmButton: {
                navigationState.push(id: "new-task", data: ["id": task.id])
            }
            
            taskDetail
            
            
            jiraDetail
            
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
    
    var jiraDetail: some View {
        VStack(alignment: .leading) {
            if task.jiraCard?.isEmpty == false {
                VStack(alignment: .leading) {
                    Text(jiraCardDetail?.summary ?? "")
                }
                .frame(maxWidth: .infinity)
                .onAppear {
                    jiraController.loadStatuses()
                    jiraController.loadIssueDetail(by: task.jiraCard!) { detail in
                        jiraCardDetail = detail
                    }
                }
            }
        }
        
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let task = TaskModel(title: "Some teng", timestamp: "")
        let date = Date.now
        task.timestamp = date.ISO8601Format()
        task.jiraCard = "PBI-534"
        return TaskDetailView(id: task.id, task: task)
            .environmentObject(PreferenceController.instance)
            .environmentObject(JiraController.instance)
    }
}
