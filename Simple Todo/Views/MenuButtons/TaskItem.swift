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
    @EnvironmentObject var navigationState: MyNavigationState
    
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
            
            MyMenuButton(expanded:true) { isHovered in
                AnyView(
                    HStack {
                        VStack {
                            if task.jiraCard?.isEmpty == false {
                                HStack {
                                    Text("[\(task.jiraCard!)]")
                                        .font(.system(size: 11))
                                    if let jiraStatus = task.jiraStatus, !jiraStatus.isEmpty {
                                        Text(jiraStatus.uppercased())
                                            .font(.system(size: 10))
                                            .foregroundStyle(.secondary)
                                            .foregroundColor(ColorTheme.instance.textDefault)
                                            .padding(EdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4))
                                            .background(.ultraThinMaterial)
                                            .cornerRadius(4)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            VStack {
                                Text(task.title)
                                    .lineLimit(1)
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
                                            .foregroundColor(task.isOverdue() ? ColorTheme.instance.warning :
                                                                isHovered ? ColorTheme.instance.staticWhite : ColorTheme.instance.textDefault)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        
                        MyNavigationLink(id: task.id, autoRedirect: false, expanded: false) {
                            EmptyView()
                        } destination: {
                            TaskDetailView(id: task.id, task: task)
                        }
                        .frame(maxWidth: 0, maxHeight: 0)
                        .opacity(0)
                    }
                        .padding(smallPadding)
                        .contentShape(Rectangle())
                )
            } callback: {
                navigationState.push(id: task.id)
            }
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(smallPadding)
    }
}

struct TaskItem_Previews: PreviewProvider {
    static var previews: some View {
        let task = TaskModel(title: "Some title long title some title long title some title long title some title long title some title long title", timestamp: "")
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
        .environmentObject(MyNavigationState())
    }
}
