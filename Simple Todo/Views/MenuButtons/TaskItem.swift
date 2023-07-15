//
//  TaskItem.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 30/06/23.
//

import SwiftUI

struct TaskItem: View {
    @EnvironmentObject var taskDelegate: TaskDelegate
    @EnvironmentObject var jiraController: JiraController
    
    var task: TaskModel
    @State var isCompleted: Bool
    @State var isCheckmarkHovered: Bool = false
    
    init(task: TaskModel, isCompleted: Bool) {
        self.task = task
        self.isCompleted = isCompleted
    }
    
    var body: some View {
        HStack {
            Button{
                isCompleted.toggle()
                task.update(status: isCompleted ? .completed : .created)
                taskDelegate.saveTask(task)
            } label: {
                HStack {
                    if isCompleted {
                        if isCheckmarkHovered {
                            Image(systemName: "circle.dashed.inset.filled")
                            
                        } else {
                            Image(systemName: "checkmark.circle")
                        }
                    } else {
                        if isCheckmarkHovered {
                            Image(systemName: "checkmark.circle.fill")
                        } else {
                            Image(systemName: "circle.dashed")
                        }
                    }
                }
                .foregroundColor(isCheckmarkHovered ? .blue : nil)
            }
            .buttonStyle(.plain)
            .onHover { hovered in
                isCheckmarkHovered = hovered
            }
            
            MyNavigationLink(id: task.id) {
                HStack {
                    VStack {
                        if task.jiraCard?.isEmpty == false {
                            HStack {
                                Text("[\(task.jiraCard!)]")
                                    .foregroundColor(ColorTheme.instance.textDefault)
                                    .font(.system(size: 11))
                                if let jiraStatus = task.jiraStatus, !jiraStatus.isEmpty {
                                    Text(jiraStatus.uppercased())
                                        .font(.system(size: 10))
                                        .foregroundColor(ColorTheme.instance.textDefault)
                                        .padding(EdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4))
                                        .background(ColorTheme.instance.textButtonInactive.opacity(0.5))
                                        .cornerRadius(4)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        VStack {
                            Text(task.title)
                                .foregroundColor(ColorTheme.instance.textDefault)
                                .strikethrough(task.status == .completed)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            if !task.timestamp.isEmpty {
                                HStack {
                                    if task.isOverdue() && task.status != .completed {
                                        Text("❗️")
                                            .font(.system(size: 11))
                                    } else {
                                        Text("🔔")
                                            .font(.system(size: 10))
                                    }
                                    Text(task.formattedDate())
                                        .font(.system(size: 11))
                                        .foregroundColor(task.isOverdue() ? ColorTheme.instance.warning : nil)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(smallPadding)
                .contentShape(Rectangle())
            } destination: {
                TaskDetailView(id: task.id, task: task)
            }
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(smallPadding)
    }
}

struct TaskItem_Previews: PreviewProvider {
    static var previews: some View {
        let task = TaskModel(title: "Some title", timestamp: "")
        task.status = .created
        let date = Date.now
        task.timestamp = date.ISO8601Format()
        task.jiraCard = "PBI-534"
        task.jiraStatus = "Devbox Done"
        return TaskItem(
            task: task,
            isCompleted: task.status == .completed)
        .environmentObject(MyNavigationState())
        .environmentObject(TaskDelegate.instance)
        .environmentObject(JiraController.instance)
    }
}
