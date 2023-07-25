//
//  TaskDetailView.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 30/06/23.
//

import SwiftUI
import MarkdownUI

struct TaskDetailView: View {
    @EnvironmentObject var navigationState: MyNavigationState
    @EnvironmentObject var taskDelegate: TaskDelegate
    @EnvironmentObject var preferenceController: PreferenceController
    @EnvironmentObject var jiraController: JiraController
    var id: String
    @State var task: TaskModel
    @State var jiraCardDetail: JiraCardDetail? = nil
    @State var isLoading: Bool = false
    @State var isStatusLoading: Bool = false
    @State var transitions: [JiraTransition] = []
    @State var currentStatus: String = ""
    @State var isUpdateSuccess: Bool = true
    @State var updateResponse: String = ""
    @State var shouldShowToast: Bool = false
    @State var isCommentAdded: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                MyNavigationBar(title: "Detail", confirmText: "Edit") {
                    navigationState.pop()
                } onConfirmButton: {
                    navigationState.push(id: "new-task", data: ["id": task.id])
                }
                
                ZStack {
                    VStack {
                        taskDetail
                        
                        if preferenceController.hasJiraAuthKey() && task.jiraCard?.isEmpty == false {
                            jiraDetail
                        }
                        
                    }
                    MyToast(isShowing: $shouldShowToast, title: updateResponse, type: isUpdateSuccess ? .Success : .Error)
                    
                }
                
                HStack {
                    Button {
                        taskDelegate.delete(task: task)
                        navigationState.pop()
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
        .frame(maxHeight: 1000, alignment: .top)
    }
    
    var taskDetail: some View {
        VStack {
            HStack {
                Text("Title")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Status")
                    .frame(maxWidth: 150, alignment: .leading)
            }
            .padding(EdgeInsets(top: 8, leading: 0, bottom: 4, trailing: 0))
            .frame(maxWidth: .infinity)
            Divider()
            HStack {
                Text(task.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(String(describing: task.status))
                    .frame(maxWidth: 150, alignment: .leading)
            }
            .padding(EdgeInsets(top: 2, leading: 0, bottom: 8, trailing: 0))
            .frame(maxWidth: .infinity)
        }
        .onAppear{
            if let task = taskDelegate.getTask(by: id) {
                self.task = task
            }
        }
        .padding(defaultPadding)
        .background(.gray.opacity(0.1))
        .cornerRadius(8)
        .padding(defaultPadding)
    }
    
    var jiraDetail: some View {
        HStack {
            if isLoading {
                loadingView
            } else {
                VStack {
                    // MARK: title
                    Text("[\(task.jiraCard ?? "")] \(jiraCardDetail?.summary ?? "")")
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    // end title
                    
                    
                    // MARK: labels
                    if let labels = jiraCardDetail?.labels, !labels.isEmpty {
                        HStack {
                            ForEach(labels, id: \.self) { label in
                                Text(label)
                                    .padding(EdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4))
                                    .background(ColorTheme.instance.textInactive.opacity(0.3))
                                    .cornerRadius(4)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    // end labels
                    
                    Divider()
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    
                    // MARK: description
                    DisclosureGroup("Description:") {
                        ScrollView {
                            Markdown(jiraCardDetail?.description?.findAndReplaceQuote()
                                .findAndReplaceLink()
                                .findAndReplaceCode()
                                     ?? "")
                            .markdownBlockStyle(\.blockquote) { configuration in
                                configuration
                                    .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                                    .overlay(alignment: .leading) {
                                        Rectangle()
                                            .fill(ColorTheme.instance.textDefault.opacity(0.1))
                                            .frame(width: 4)
                                    }
                                    .background(ColorTheme.instance.textInactive.opacity(0.3))
                                    .foregroundColor(ColorTheme.instance.textDefault.opacity(0.6))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .markdownTextStyle(\.code, textStyle: {
                                ForegroundColor(ColorTheme.instance.textDefault)
                                FontFamilyVariant(.monospaced)
                                BackgroundColor(ColorTheme.instance.textDefault.opacity(0.2))
                                FontSize(12)
                            })
                                .padding(8)
                                .background(ColorTheme.instance.textInactive.opacity(0.1))
                        }
                        .cornerRadius(8)
                            .frame(maxWidth: .infinity, maxHeight: 300, alignment: .topLeading)
                    }
                    // end description
                    
                    Divider()
                    
                    // MARK: comments
                    if let jiraCard = task.jiraCard {
                        DisclosureGroup("Comments:") {
                            VStack {
                                CommentEditorView(
                                    taskId: jiraCard,
                                    commentAdded: $isCommentAdded
                                )
                                .onChange(of: isCommentAdded, perform: { success in
                                    withAnimation {
                                        shouldShowToast = true
                                        isUpdateSuccess = success
                                        if success {
                                            updateResponse = "Comment added"
                                        } else {
                                            updateResponse = "Failed to save comment"
                                        }
                                    }
                                })
                                .cornerRadius(8)
                                    .frame(minHeight: 40)
                                ScrollView {
                                    IssueCommentView(jiraKey: jiraCard)
                                }
                                .cornerRadius(8)
                            }
                            .cornerRadius(8)
                                .frame(maxWidth: .infinity, maxHeight: 300, alignment: .topLeading)
                        }
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8))
                
                Divider()
                
                VStack {
                    
                    // MARK: open in browser link
                    if let host = preferenceController.preference.jiraServerUrl, let path = jiraCardDetail?.browseUrl(host: host), let url = URL(string: path) {
                        Link(destination: url) {
                            HStack {
                                Text("Open in browser")
                                    .font(.system(size: 10))
                                    .foregroundColor(ColorTheme.instance.textButtonDefault)
                                Spacer()
                                Image(systemName: "arrow.up.right")
                                    .foregroundColor(ColorTheme.instance.textButtonDefault)
                                    .scaleEffect(0.8)
                            }
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    // end link
                    
                    // MARK: transition
                    Text("Status")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                    if isStatusLoading {
                        loadingView
                    } else {
                        Picker("", selection: $currentStatus) {
                            ForEach(transitions) { status in
                                if status.id == jiraCardDetail?.statusId || status.id == jiraCardDetail?.transitionId {
                                    Text(status.name.uppercased())
                                        .tag(status.id)
                                } else {
                                    HStack {
                                        if status.name.lowercased() != status.to.name.lowercased() {
                                            Text("\(status.name) → \(status.to.name.uppercased())")
                                        } else {
                                            Text("Transition to → \(status.to.name.uppercased())")
                                        }
                                    }.tag(status.id)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .onChange(of: currentStatus) { newStatus in
                            guard let selectedTransition = transitions.first(where: { transition in
                                transition.id == newStatus
                            }) else {
                                return
                            }
                            
                            if newStatus != jiraCardDetail?.transitionId && newStatus != jiraCardDetail?.statusId {
                                isStatusLoading = true
                                jiraController.updateIssueStatus(by: task.jiraCard!, to: selectedTransition) { success in
                                    withAnimation {
                                        isUpdateSuccess = success
                                        shouldShowToast = true
                                        if success {
                                            jiraCardDetail?.transitionId = newStatus
                                            updateResponse = "Transitioned to \(selectedTransition.to.name.uppercased())"
                                            currentStatus = ""
                                            loadIssueDetail()
                                        } else {
                                            updateResponse = "Failed to set Transition"
                                            isStatusLoading = false
                                        }
                                    }
                                }
                            }
                        }
                    }
                    // end transition
                    
                    
                    Divider()
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                    
                    VStack {
                        // MARK: assignee
                        if let assignee = jiraCardDetail?.assignee {
                            Text("Assignee:")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            HStack {
                                AsyncImage(url: URL(string: jiraCardDetail?.assigneeAvatar ?? ""))
                                    .frame(width: 16, height: 16)
                                    .clipShape(Circle())
                                Text(assignee)
                                if preferenceController.preference.jiraEmail == jiraCardDetail?.assigneeEmail {
                                    Text("(Me)")
                                }
                                
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            Text("Assignee: None")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        // end assignee
                        
                        // MARK: due date
                        if let duedate = jiraCardDetail?.dueDate?.asFormattedDate() {
                            HStack {
                                Text("Due date:")
                                Text(duedate)
                            }
                            .frame(maxWidth: .infinity, alignment:.leading)
                        }
                        // end due date
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                    
                    Spacer()
                } // end VStack
                .frame(maxWidth: 170, alignment: .leading)
            }
        } // end HStack
        .frame(alignment: .topLeading)
        .padding(8.0)
        .background(.gray.opacity(0.1))
        .cornerRadius(8)
        .padding(8.0)
        .onAppear {
            isLoading = true
            loadIssueDetail()
        }
    }
    
    func loadIssueDetail() {
        jiraController.loadIssueDetail(by: task.jiraCard!) { detail in
            self.jiraCardDetail = detail
            self.task.jiraStatus = detail?.status
            self.taskDelegate.saveTask(task)
            if detail != nil && detail!.issueType != nil {
                self.loadTransition()
            } else {
                isLoading = false
                isStatusLoading = false
            }
        }
    }
    
    func loadTransition() {
        defer {
            isLoading = false
            isStatusLoading = false
        }
        guard let detail = jiraCardDetail else {
            return
        }
        
        jiraController.loadTransition(by: task.jiraCard!) { transitions in
            self.transitions.removeAll()
            self.transitions = transitions ?? []
            self.jiraCardDetail?.transitionId = self.transitions.first { tr in
                tr.to.id == detail.statusId
            }?.id
            if (currentStatus.isEmpty && jiraCardDetail?.statusId?.isEmpty == false) {
                self.transitions.insert(JiraTransition(id: jiraCardDetail?.statusId! ?? "", name: jiraCardDetail?.status ?? "", hasScreen: false, isGlobal: false, isInitial: true, isConditional: true, isLooped: false, to: TransitionTo.empty), at: 0)
            }
            currentStatus = self.jiraCardDetail?.transitionId ?? jiraCardDetail?.statusId ?? ""
        }
    }
    
    var loadingView: some View {
        HStack {
            ProgressView()
                .progressViewStyle(.circular)
                .scaleEffect(0.5)
        }
        .frame(maxWidth: .infinity)
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let task = TaskModel(title: "Some teng", timestamp: "")
        let date = Date.now
        task.timestamp = date.ISO8601Format()
        task.jiraCard = "ST-1"
        return TaskDetailView(id: task.id, task: task)
            .environmentObject(PreferenceController.instance)
            .environmentObject(JiraController.instance)
            .environmentObject(MyNavigationState())
            .environmentObject(PreferenceController.instance)
    }
}
