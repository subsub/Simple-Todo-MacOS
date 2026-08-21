//
//  MainMenuView.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 29/06/23.
//

import SwiftUI

private struct MenuMaximumHeightKey: EnvironmentKey {
    static let defaultValue: CGFloat = 600
}

extension EnvironmentValues {
    var menuMaximumHeight: CGFloat {
        get { self[MenuMaximumHeightKey.self] }
        set { self[MenuMaximumHeightKey.self] = newValue }
    }
}

private struct HeaderHeightPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { value = nextValue() }
}

struct MainMenuView: View {
    @EnvironmentObject var taskDelegate: TaskDelegate
    @EnvironmentObject var notificationController: NotificationController
    @EnvironmentObject var preferenceController: PreferenceController
    @Environment(\.screenHeight) var screenHeight: CGFloat
    @Environment(\.menuMaximumHeight) var menuMaximumHeight: CGFloat
    @State var keyObserver: NSKeyValueObservation?
    @State private var headerHeight: CGFloat = 44

    private var fixedFooterHeight: CGFloat {
        preferenceController.isPasteboardsEnabled() ? 240 : 205
    }

    private var maximumTaskListHeight: CGFloat {
        max(1, menuMaximumHeight - headerHeight - fixedFooterHeight - 8)
    }

    private var taskListHeight: CGFloat {
        min(estimatedTaskListContentHeight, maximumTaskListHeight)
    }

    private var estimatedTaskListContentHeight: CGFloat {
        let tasks = taskDelegate.uncompletedTask() + taskDelegate.completedTask()
        let taskRowsHeight = tasks.reduce(CGFloat.zero) { height, task in
            let hasSecondaryLine = !task.timestamp.isEmpty || task.jiraCard?.isEmpty == false
            return height + (hasSecondaryLine ? 66 : 48)
        }
        let jiraRowHeight: CGFloat = preferenceController.hasJiraAuthKey() ? 34 : 0

        // TaskList contains two section labels, a divider, and vertical padding.
        return 72 + jiraRowHeight + taskRowsHeight
    }
    
    var body: some View {
        MyNavigationController {
            VStack(spacing: 0) {
                VStack {
                    ZStack {
                        // hidden navigation link for new-task
                        MyNavigationLink(id: "new-task", colorDelegate: ColorTheme.instance, autoRedirect: false, expanded: false, padding: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)) {
                            EmptyView()
                        } destination: {
                            NewTaskView()
                        }
                        .frame(width: 0, height: 0)

                        NewTaskButton()
                    }

                    Divider()
                }
                .background(heightReader(HeaderHeightPreferenceKey.self))

                ScrollView {
                    taskListContent
                    .onAppear {
                        keyObserver = NSApplication.shared.observe(\.keyWindow) { x, y in
                            print("Is Visible: \(NSApplication.shared.keyWindow != nil)")
                            if (NSApplication.shared.keyWindow != nil) {
                                taskDelegate.loadTasks()
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .frame(height: taskListHeight, alignment: .topLeading)

                VStack {
                    
                    Divider()
                    
                    DeleteAllDoneButton()
                    
                    ClearButton()
                    
                    if preferenceController.isPasteboardsEnabled() {
                        Divider()
                        Pasteboards()
                    }
                    
                    Divider()
                    PreferenceButton()
                    
                    Divider()
                    
                    QuitButton()
                    
                }
            }
            .onPreferenceChange(HeaderHeightPreferenceKey.self) { headerHeight = $0 }
        }
        .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
        .frame(maxHeight: menuMaximumHeight, alignment: .topLeading)
    }

    private var taskListContent: some View {
        VStack {
            if preferenceController.hasJiraAuthKey() {
                IssueTrackerButton()
                Divider()
            }
            TaskList()
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }

    private func heightReader<Key: PreferenceKey>(_ key: Key.Type) -> some View where Key.Value == CGFloat {
        GeometryReader { proxy in
            Color.clear.preference(key: key, value: proxy.size.height)
        }
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
            .environmentObject(TaskDelegate.instance)
            .environmentObject(PreferenceController.instance)
    }
}
