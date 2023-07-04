//
//  StatusMenuView.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 29/06/23.
//

import SwiftUI

struct StatusMenuView: View {
    @EnvironmentObject var taskDelegate: TaskDelegate
    @EnvironmentObject var bgScheduler: BackgroundTaskController
    
    @State var reloadCount: Double = 0
    
    var body: some View {
        HStack {
            statusIcon
            statusText
        }.padding(4)
            .onChange(of: bgScheduler.reloadCount) { newValue in
                reloadCount += 1
                print(">> reloadCount: \(reloadCount)")
            }
    }
    
    var statusIcon: some View {
        if taskDelegate.totalTask() == 0  || taskDelegate.totalCompletedTask() == taskDelegate.totalTask() {
            return AnyView(Image(systemName: "checkmark.circle.fill"))
        } else if taskDelegate.totalCompletedTask() == 0 {
            return AnyView(Image(systemName: "checklist.unchecked"))
        } else {
            return AnyView(Image(systemName: "checklist"))
        }
    }
    
    var statusText: some View {
        if taskDelegate.totalOverdueTasks() > 0 {
            return Text("\(taskDelegate.totalTask() - taskDelegate.totalCompletedTask()) tasks❗️\(taskDelegate.totalOverdueTasks()) overdue")
        } else if taskDelegate.totalTask() == 0 || taskDelegate.totalCompletedTask() == taskDelegate.totalTask() {
            return Text("All Clear")
        } else {
            return Text("\(taskDelegate.totalTask() - taskDelegate.totalCompletedTask()) tasks")
        }
    }
}

struct StatusMenuView_Previews: PreviewProvider {
    static var previews: some View {
        StatusMenuView()
            .environmentObject(TaskDelegate.instance)
            .environmentObject(BackgroundTaskController.instance)
    }
}
