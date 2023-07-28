//
//  IssueTrackerListView.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 04/07/23.
//

import SwiftUI

struct IssueTrackerListView: View {
    enum Field : Hashable {
        case search
        case none
    }
    @EnvironmentObject var taskDelegate: TaskDelegate
    @EnvironmentObject var navigationState: MyNavigationState
    @EnvironmentObject var jiraController: JiraController
    @State var isLoading: Bool = false
    @State var taskList: [MyJiraTaskItem] = []
    @State var message: String = ""
    @State var shouldShowToast: Bool = false
    @State var createdTask: TaskModel? = nil
    
    @State var isSearching: Bool = false
    @State var searchKey: String = ""
    @State var searchResult: [JiraCardDetail] = []
    @State var searchError: String = ""
    @FocusState var focusedState: Field?
    
    var body: some View {
        VStack {
            MyNavigationBar {
                HStack{
                    Text("Issue Tracker")
                        .frame(maxWidth: .infinity)
                    
                    
                    if isSearching {
                        TextField("Search Key", text: $searchKey)
                            .onChange(of: searchKey, perform: { newValue in
                                if newValue.isEmpty {
                                    searchResult.removeAll()
                                    searchError = ""
                                }
                            })
                            .focused($focusedState, equals: .search)
                            .onSubmit {
                                search()
                            }
                            .textFieldStyle(.plain)
                            .frame(maxHeight: .infinity)
                            .padding(smallPadding)
                            .background(ColorTheme.instance.textInactive.opacity(0.5))
                            .cornerRadius(4)
                            .transition(.move(edge: .trailing).combined(with: .opacity))
                        
                    }
                    Button {
                        withAnimation {
                            isSearching.toggle()
                            if !isSearching {
                                searchKey = ""
                                searchResult.removeAll()
                                focusedState = Field.none
                                searchError = ""
                            } else {
                                focusedState = Field.search
                            }
                        }
                    } label: {
                        if isSearching {
                            Image(systemName: "xmark")
                        } else {
                            Image(systemName: "magnifyingglass")
                        }
                    }
                    .buttonStyle(.plain)
                }
                .frame(maxHeight: 24)
            } onBackButton: {
                navigationState.pop()
            }
            
            ZStack(alignment: .topTrailing) {
                if isLoading && !isSearching {
                    ProgressView()
                        .scaleEffect(0.5)
                } else {
                    issueItem
                }
                
                
                if isSearching {
                    searchItem
                }
            }
        }
        .frame(minWidth: 500)
        .onAppear {
            isLoading = true
            jiraController.getMyTaskList { myTasks in
                isLoading = false
                taskList = myTasks ?? []
            }
        }
    }
    
    var tableHeader: some View {
        HStack {
            HStack {
                Text("Key")
            }
            .frame(maxWidth: 60, alignment: .leading)
            
            HStack {
                Text("Summary")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Text("Status")
            }
            .frame(maxWidth: 110, alignment: .leading)
            
            
            HStack {
                Text("Action")
            }
            .frame(maxWidth: 100, alignment: .leading)
            
        }
        .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
    }
    
    var searchTableHeader: some View {
        HStack {
            HStack {
                Text("Key")
            }
            .frame(maxWidth: 60, alignment: .leading)
            
            HStack {
                Text("Summary")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    var issueItem: some View {
        VStack {
            tableHeader
            
            Divider()
            
            ForEach(taskList, id: \.id) { task in
                if let taskKey = task.key {
                    VStack {
                        HStack {
                            HStack {
                                Text(taskKey)
                            }
                            .frame(maxWidth: 60, alignment: .leading)
                            
                            HStack {
                                Text(task.summary ?? "")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack {
                                if let status = task.status?.name {
                                    Text(status.uppercased())
                                        .font(.system(size: 10))
                                        .foregroundColor(ColorTheme.instance.textDefault)
                                        .padding(EdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4))
                                        .background(ColorTheme.instance.textButtonInactive.opacity(0.5))
                                        .cornerRadius(4)
                                }
                            }
                            .frame(maxWidth: 80, alignment: .leading)
                            
                            actionLink(jiraTask: task)
                                .frame(maxWidth: 130, alignment: .leading)
                            
                        }
                    }
                    Divider()
                }
            }
        }
        .padding(defaultPadding)
        .background(.gray.opacity(0.1))
        .cornerRadius(8)
        .padding(EdgeInsets(top: 0, leading: 8, bottom: 8, trailing: 8))
        
    }
    
    var searchItem: some View {
        VStack {
            if isLoading {
                ProgressView()
                    .scaleEffect(0.5)
                    .frame(maxWidth: 250)
                    .padding(defaultPadding)
                    .background(.ultraThinMaterial)
                    .shadow(color: ColorTheme.instance.defaultShadow, radius: 10)
            } else if !searchResult.isEmpty {
                ScrollView {
                    searchTableHeader
                        .padding(EdgeInsets(top: 8, leading: 18, bottom: 0, trailing: 12))
                    
                    Divider()
                    
                    ForEach(searchResult, id: \.id) { result in
                        MyMenuButton { _ in
                            AnyView(
                                HStack {
                                    HStack {
                                        Text(result.key ?? "")
                                    }
                                    .frame(maxWidth: 60, alignment: .leading)
                                    
                                    HStack {
                                        Text(result.summary ?? "")
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                }
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            )
                        } callback: {
                            var data: [String: Any] = [:]
                            if let key = result.key {
                                data["jiraCard"] = key
                            }
                            if let summary = result.summary {
                                data["jiraSummary"] = summary
                            }
                            navigationState.push(id: "new-task", data: data)
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 8, trailing: 8))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .frame(maxWidth: 250, maxHeight: 200)
                .background(.ultraThinMaterial)
                .shadow(color: ColorTheme.instance.defaultShadow, radius: 10)
            } else if !searchError.isEmpty {
                Text(searchError)
                .frame(maxWidth: 250)
                .padding(defaultPadding)
                .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                .background(.ultraThinMaterial)
                .shadow(color: ColorTheme.instance.defaultShadow, radius: 10)
            }
        }
    }
    
    func actionLink(jiraTask: MyJiraTaskItem) -> AnyView {
        let (taskExists, task) = taskDelegate.hasTask(jiraId: jiraTask.key ?? "")
        
        return AnyView(
            HStack {
                if taskExists && task != nil {
                    MyNavigationLink(id: task!.id) {
                        HStack {
                            Text("Detail →")
                        }
                    } destination: {
                        TaskDetailView(id: task!.id, task: task!)
                    }
                } else {
                    MyMenuButton { isHovered in
                        AnyView(
                            Text("As New Task →")
                                .foregroundColor(isHovered ? ColorTheme.instance.textDefault : ColorTheme.instance.textButtonDefault)
                        )
                    } callback: {
                        createNewTask(jiraTask: jiraTask)
                    }
                    .buttonStyle(.plain)
                    if createdTask != nil {
                        MyNavigationLink(id: createdTask!.id) {
                            EmptyView()
                        } destination: {
                            TaskDetailView(id: createdTask!.id, task: createdTask!)
                        }
                        .frame(maxWidth: 0)
                    }
                }
            }
        )
    }
    
    
    func createNewTask(jiraTask: MyJiraTaskItem) {
        guard let key = jiraTask.key, let summary = jiraTask.summary else {
            return
        }
        
        let task = TaskModel(
            title: summary,
            timestamp: "")
        
        isLoading = true
        jiraController.loadIssueDetail(by: key) { jiraDetail in
            isLoading = false
            guard let detail = jiraDetail else {
                message = "Issue not found: \(key)"
                withAnimation {
                    shouldShowToast = true
                }
                return
            }
            task.setJiraCard(key)
            task.jiraStatus = detail.status
            save(task: task)
        }
    }
    
    func save(task: TaskModel) {
        createdTask = task
        taskDelegate.saveTask(task)
        navigationState.push(id: task.id)
    }
    
    func search() {
        isLoading = true
        jiraController.searchIssue(by: searchKey) { issueList in
            isLoading = false
            searchResult = issueList
            if searchResult.isEmpty {
                searchError = "No Issue Found"
            } else {
                searchError = ""
            }
        }
    }
}

struct IssueTrackerListView_Previews: PreviewProvider {
    static var previews: some View {
        IssueTrackerListView()
            .environmentObject(MyNavigationState())
            .environmentObject(JiraController.instance)
            .environmentObject(TaskDelegate.instance)
    }
}
