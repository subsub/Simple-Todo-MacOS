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
    
    @State var username: String = ""
    @State var apiKey: String = ""
    @State var jiraHost: String = ""
    
    var body: some View {
        VStack {
            MyNavigationBar(title: "Jira Integration", confirmText: "Save", confirmButtonEnabled: !username.isEmpty && !apiKey.isEmpty && !jiraHost.isEmpty) {
                navigationState.popTo(id: "preference")
            } onConfirmButton: {
                preferenceController.saveJiraAuth(username: username, apiKey: apiKey, host: jiraHost)
                navigationState.popTo(id: "preference")
            }
            
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
                    TextField("https://host.attlasian.net", text: $jiraHost)
                        .frame(maxHeight: 40)
                }
            }
            .padding(defaultPadding)
            
            Text("To use Jira App, you need an API key. Read on how to create Jira API key here: https://support.atlassian.com/atlassian-account/docs/manage-api-tokens-for-your-atlassian-account/")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(defaultPadding)
                .background(.gray.opacity(0.1))
                .padding(defaultPadding)
        }
        .frame(minWidth: 450)
    }
}

struct JiraAuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        JiraAuthenticationView()
            .environmentObject(MyNavigationState())
    }
}
