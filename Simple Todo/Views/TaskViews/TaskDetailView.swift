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
    var task: TaskModel
    @State var jiraCardDetail: JiraCardDetail? = nil
    @State var isLoading: Bool = false
    @State var transitions: [JiraTransition] = []
    @State var currentStatus: String = ""
    @State var isUpdateSuccess: Bool = true
    @State var updateResponse: String = ""
    
    var body: some View {
        ScrollView {
            VStack {
                MyNavigationBar(title: "Detail", confirmText: "Edit") {
                    navigationState.popTo(id: nil)
                } onConfirmButton: {
                    navigationState.push(id: "new-task", data: ["id": task.id])
                }
                
                ZStack {
                    VStack {
                        taskDetail
                        
                        jiraDetail
                        
                    }
                    VStack {
                        if !updateResponse.isEmpty {
                            Text(updateResponse)
                                .padding(defaultPadding)
                                .background((isUpdateSuccess ? ToastType.Success : ToastType.Error).backgroundColor())
                                .transition(.move(edge: .top))
                                .cornerRadius(4)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                        withAnimation {
                                            updateResponse = ""
                                        }
                                    }
                                }
                        }
                        //                        MyToast(isShowing: !updateResponse.isEmpty, title: updateResponse, type: isUpdateSuccess ? .Success : .Error)
                    }
                    .frame(maxHeight: .infinity, alignment: .topLeading)
                    
                }
                
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
        .frame(maxHeight: 1000, alignment: .top)
    }
    
    var taskDetail: some View {
        VStack {
            HStack {
                Text("Title")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Due At")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Status")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(EdgeInsets(top: 8, leading: 0, bottom: 4, trailing: 0))
            .frame(maxWidth: .infinity)
            Divider()
            HStack {
                Text(task.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(task.formattedDate())
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(String(describing: task.status))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(EdgeInsets(top: 2, leading: 0, bottom: 8, trailing: 0))
            .frame(maxWidth: .infinity)
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
                                    .background(.gray.opacity(0.3))
                                    .cornerRadius(4)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    // end labels
                    
                    Divider()
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    
                    // MARK: description
                    DisclosureGroup("Description") {
                        Markdown(jiraCardDetail?.description ?? "")
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    }
                    // end description
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8))
                
                Divider()
                
                VStack {
                    // MARK: transition
                    Text("Status")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                    Picker("", selection: $currentStatus) {
                        ForEach(transitions) { status in
                            if status.id == jiraCardDetail?.statusId {
                                Text(status.name)
                                    .tag(status.id)
                            } else {
                                Text("Transition to \(status.name)")
                                    .tag(status.id)
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
                            isLoading = true
                            jiraController.updateIssueStatus(by: task.jiraCard!, to: selectedTransition) { success in
                                withAnimation {
                                    isLoading = false
                                    isUpdateSuccess = success
                                    if success {
                                        jiraCardDetail?.transitionId = newStatus
                                        updateResponse = "Transition set to \(selectedTransition.name)"
                                    } else {
                                        updateResponse = "Failed to set Transition"
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
            jiraController.loadIssueDetail(by: task.jiraCard!) { detail in
                jiraCardDetail = detail
                if detail != nil && detail!.issueType != nil {
                    jiraController.loadTransition(by: task.jiraCard!, of: detail!.issueType!) { transitions in
                        self.transitions = transitions ?? []
                        self.jiraCardDetail?.transitionId = self.transitions.first { tr in
                            tr.to.id == detail!.statusId
                        }?.id
                        if (currentStatus.isEmpty && jiraCardDetail?.statusId?.isEmpty == false) {
                            self.transitions.insert(JiraTransition(id: jiraCardDetail?.statusId! ?? "", name: jiraCardDetail?.status ?? "", hasScreen: false, isGlobal: false, isInitial: true, isConditional: true, isLooped: false, to: TransitionTo.empty), at: 0)
                        }
                        currentStatus = self.jiraCardDetail?.transitionId ?? jiraCardDetail?.statusId ?? ""
                        isLoading = false
                    }
                } else {
                    isLoading = false
                }
            }
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
        task.jiraCard = "PBI-534"
        return TaskDetailView(id: task.id, task: task)
            .environmentObject(PreferenceController.instance)
            .environmentObject(JiraController.instance)
    }
}
