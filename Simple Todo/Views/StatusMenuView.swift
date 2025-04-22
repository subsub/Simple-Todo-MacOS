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
    @EnvironmentObject var prefController: PreferenceController
    
    @State var reloadCount: Double = 0
    @State var newPasteboardContent: String? = nil
    
    @State private var textoffset = 300.0
    @State var timer: Timer? = nil
    
    var body: some View {
        HStack {
            statusIcon
            Color.clear
                .frame(width: 250)
                .overlay {
                    statusText
                        .fixedSize()
                        .offset(x: textoffset, y: 0)
                }
                .animation(
                    .linear(duration: 10)
                    .repeatForever(autoreverses: false), value: textoffset)
                .clipped()
        }
        .padding(4)
        .onAppear {
            textoffset = -300.0
        }
        .onChange(of: bgScheduler.reloadCount) { newValue in
            reloadCount += 1
            print(">> reloadCount: \(reloadCount)")
        }
        .onReceive(prefController.$preferenceEvent) { output in
            switch output {
            case .newPasteboardData(var newContent):
                guard prefController.isPasteboardsEnabled() else {
                    return
                }
                newContent = newContent.replacing(/\s+/, with: " ")
                newPasteboardContent = newContent.count > 20 ? "\(String(newContent[..<newContent.index(newContent.startIndex, offsetBy: 20)]))..." : newContent
                if timer?.isValid == true {
                    timer?.invalidate()
                }
                timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { _ in
                    newPasteboardContent = nil
                    timer?.invalidate()
                })
                return
            case .deletePasteboardData(let _):
                return
            case .none:
                return
            }
        }
    }
    
    var statusIcon: some View {
        if let _ = newPasteboardContent {
            return AnyView(Image(systemName: "list.clipboard.fill"))
        }
        if taskDelegate.totalTask() == 0  || taskDelegate.totalCompletedTask() == taskDelegate.totalTask() {
            return AnyView(Image(systemName: "checkmark.circle.fill"))
        } else if taskDelegate.totalCompletedTask() == 0 {
            return AnyView(Image(systemName: "checklist.unchecked"))
        } else {
            return AnyView(Image(systemName: "checklist"))
        }
    }
    
    var statusText: some View {
        if let pastboardContent = newPasteboardContent {
            return Text("← \"\(pastboardContent)\"")
        }
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
