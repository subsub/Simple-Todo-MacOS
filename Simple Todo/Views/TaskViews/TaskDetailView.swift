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
        .cornerRadius(12)
        .padding(defaultPadding)
    }
    
    var jiraDetail: some View {
        VStack(alignment: .leading) {
            if task.jiraCard?.isEmpty == false && preferenceController.hasJiraAuthKey() {
                VStack {
                    Text("[\(task.jiraCard!)] \(jiraCardDetail?.summary ?? "")")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 4, leading: 0, bottom: 0, trailing: 0))
                    HStack {
                        if let labels = jiraCardDetail?.labels, !labels.isEmpty {
                            ForEach(labels, id: \.self) { label in
                                Text(label)
                                    .padding(EdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4))
                                    .background(.orange.opacity(0.5))
                                    .cornerRadius(4)
                            }
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 4, trailing: 0))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                    if isLoading {
                        loadingView
                    } else {
                        VStack(alignment: .leading) {
                            HStack {
                                HStack {
                                    Text("Due date:")
                                    Text(jiraCardDetail?.dueDate?.asFormattedDate() ?? "-")
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                HStack {
                                    if jiraCardDetail?.statusId != nil {
                                        Picker(selection: $currentStatus, label: Text("Transition")) {
                                            ForEach(transitions) { status in
                                                Text(status.name ?? "").tag(status.id)
                                            }
                                        }
                                        .onChange(of: currentStatus) { newStatus in
                                            guard let selectedTransition = transitions.first(where: { transition in
                                                transition.id == newStatus
                                            }) else {
                                                return
                                            }
                                            
                                            print(">> newStatus: \(newStatus), currentStatus: \(jiraCardDetail?.transitionId)")
                                            
                                            if newStatus != jiraCardDetail?.transitionId {
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
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            DisclosureGroup("Description") {
                                Markdown(jiraCardDetail?.description ?? "")
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(defaultPadding)
                .background(.gray.opacity(0.1))
                .cornerRadius(12)
                .padding(defaultPadding)
                .onAppear {
                    isLoading = true
                    jiraController.loadIssueDetail(by: task.jiraCard!) { detail in
                        jiraCardDetail = detail
                        if detail != nil && detail!.issueType != nil {
                            jiraController.loadTransition(by: task.jiraCard!, of: detail!.issueType!) { transitions in
                                self.transitions = transitions ?? []
                                self.jiraCardDetail?.transitionId = self.transitions.first { tr in
                                    tr.to.id == detail!.statusId
                                }?.id ?? ""
                                currentStatus = self.jiraCardDetail?.transitionId ?? ""
                                isLoading = false
                            }
                        } else {
                            isLoading = false
                        }
                    }
                }
            }
        }
    }
    
    var loadingView: some View {
        ProgressView()
            .progressViewStyle(.circular)
            .scaleEffect(0.5)
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
