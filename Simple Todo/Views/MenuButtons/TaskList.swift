//
//  TaskList.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 29/06/23.
//

import SwiftUI
import simple_navigation

struct TaskList: View {
    @EnvironmentObject var taskDelegate: TaskDelegate
    
    var body: some View {
        tasks
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding(defaultPadding)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 4, trailing: 0))

    }
    
    var tasks: some View {
        VStack {
            Text("Ongoning Tasks")
                .foregroundColor(ColorTheme.instance.textDefault)
                .opacity(0.6)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(smallPadding)
            
            ForEach(taskDelegate.uncompletedTask(), id: \.id) { task in
                TaskItem(
                    task: task,
                    isCompleted: task.status == .completed)
            }
            
            Divider()
                .padding(EdgeInsets(top: 4, leading: 0, bottom: 0, trailing: 0))
            
            Text("Completed Tasks")
                .foregroundColor(ColorTheme.instance.textDefault)
                .opacity(0.6)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(smallPadding)
            ForEach(taskDelegate.completedTask(), id: \.id) { task in
                TaskItem(
                    task: task,
                    isCompleted: task.status == .completed)
            }
        }
    }
}

struct TaskList_Previews: PreviewProvider {
    static var previews: some View {
        TaskList()
            .environmentObject(SimpleNavigation.state())
            .environmentObject(TaskDelegate.instance)
    }
}
