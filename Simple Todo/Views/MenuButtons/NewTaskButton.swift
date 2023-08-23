//
//  NewTaskButton.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 29/06/23.
//

import SwiftUI

struct NewTaskButton: View {
    enum Field : Hashable {
        case title
    }
    @EnvironmentObject var navigationState: MyNavigationState
    @EnvironmentObject var taskDelegate: TaskDelegate
    @State var taskTitle: String = ""
    @State var isEditing: Bool = false
    @State var keyObserver: NSKeyValueObservation?
    @FocusState var focusedState: Field?
    
    var body: some View {
        ZStack {
            HStack {
                TextField("", text: $taskTitle)
                    .onSubmit {
                        save()
                    }
                    .focused($focusedState, equals: .title)
                    .onChange(of: taskTitle, perform: { title in
                        withAnimation(.easeInOut(duration: 0.1)) {
                            isEditing = !title.isEmpty
                        }
                    })
                    .textFieldStyle(.plain)
                    .padding(defaultPadding)
                    .background(.ultraThinMaterial)
                    .cornerRadius(4)
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(!isEditing ? ColorTheme.instance.textButtonDefault.opacity(0.2) : ColorTheme.instance.textButtonDefault, lineWidth: 0.5))
                    .padding(defaultPadding)
                    .frame(maxWidth: .infinity)
                if isEditing {
                    MyMenuButton(expanded: false, padding: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)) { isHovered in
                        AnyView(
                            Text("⏎")
                                .foregroundColor(isHovered ? ColorTheme.instance.textDefault : ColorTheme.instance.textButtonDefault)
                        )
                    } callback: {
                        save()
                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                    
                    MyMenuButton(expanded: false, padding: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)) { _ in
                        AnyView(
                            Text("→")
                        )
                    } callback: {
                        navigationState.push(id: "new-task", data: ["title" : taskTitle])
                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                    
                    
                    MyNavigationLink(id: "new-task", autoRedirect: false, expanded: false, padding: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 4)) {
                        Text("→")
                            .foregroundColor(ColorTheme.instance.textDefault)
                    } destination: {
                        NewTaskView()
                    }
                    .frame(maxWidth: 0.0)
                }
            }
            if !isEditing {
                Text("New Task")
                    .foregroundColor(ColorTheme.instance.textButtonDefault)
                    .frame(maxWidth: .infinity, maxHeight: 10, alignment: .leading)
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .onAppear {
            focusedState = .title
            keyObserver = NSApplication.shared.observe(\.keyWindow) { x, y in
                if (NSApplication.shared.keyWindow == nil) {
                    taskTitle = ""
                }
            }
        }
    }
    
    func save() {
        let task = TaskModel(
            title: taskTitle,
            timestamp: "")
        taskDelegate.saveTask(task)
        taskTitle = ""
    }
}

struct NewTaskButton_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskButton()
            .environmentObject(TaskDelegate.instance)
            .environmentObject(MyNavigationState())
    }
}
