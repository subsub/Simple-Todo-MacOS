//
//  JiraAuthenticationView.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 01/07/23.
//

import SwiftUI

struct JiraAuthenticationView: View {
    @EnvironmentObject var navigationState: MyNavigationState
    @EnvironmentObject var preferenceController: PreferenceController
    @EnvironmentObject var jiraController: JiraController
    @EnvironmentObject var taskDelegate: TaskDelegate
    
    @State var username: String = ""
    @State var apiKey: String = ""
    @State var jiraHost: String = ""
    @State var isLoading: Bool = false
    @State var shouldShowToast: Bool = false
    @State var isValid: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                MyNavigationBar(title: "Jira Integration", confirmText: "Save", confirmButtonEnabled: !username.isEmpty && !apiKey.isEmpty && !jiraHost.isEmpty && !isLoading) {
                    navigationState.popTo(id: "preference")
                } onConfirmButton: {
                    isLoading = true
                    checkAndConfirm()
                }
                
                ZStack {
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Username:")
                                    .frame(maxHeight: 40)
                                Text("API Key:")
                                    .frame(maxHeight: 40)
                                Text("Host:")
                                    .frame(maxHeight: 40)
                            }
                            VStack {
                                TextField("email@host.com", text: $username)
                                    .frame(maxHeight: 40)
                                TextField("API Key", text: $apiKey)
                                    .frame(maxHeight: 40)
                                HStack {
                                    TextField("host", text: $jiraHost)
                                        .frame(maxHeight: 40)
                                    Text(".atlassian.net")
                                }
                            }
                        }
                        .padding(defaultPadding)
                        
                        Text("To use Jira App, you need an API key. Read on how to create Jira API key here: https://support.atlassian.com/atlassian-account/docs/manage-api-tokens-for-your-atlassian-account/")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(defaultPadding)
                            .background(.gray.opacity(0.1))
                            .padding(defaultPadding)
                    }
                    MyToast(isShowing: $shouldShowToast, title: isValid ? "Verified" : "Cannot verify information", type: isValid ? .Success : .Error)
                }
            }
            
            if isLoading {
                ProgressView()
            }
        }
        .frame(minWidth: 450)
    }
    
    func checkAndConfirm() {
        let preference = preferenceController.getPreference(username: username, apiKey: apiKey, host: jiraHost)
        guard let username = preference.jiraEmail, let apiKey = preference.jiraAuthenticationKey, let host = preference.jiraServerUrl else {
            withAnimation {
                isLoading = false
                shouldShowToast = true
                isValid = false
            }
            return
        }
        jiraController.checkMyself(username: username, apiKey: apiKey, host: host) { success, data in
            withAnimation {
                isLoading = false
                shouldShowToast = true
                isValid = success
            }
            if success {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    if let myself = data {
                        taskDelegate.saveMyself(myself)
                    }
                    preferenceController.saveJiraAuth(from: preference)
                    navigationState.popTo(id: "preference")
                }
            }
        }
    }
}

struct JiraAuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        JiraAuthenticationView()
            .environmentObject(MyNavigationState())
            .environmentObject(JiraController.instance)
            .environmentObject(TaskDelegate.instance)
    }
}
