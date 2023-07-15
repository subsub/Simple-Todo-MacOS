//
//  PreferenceView.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 01/07/23.
//

import SwiftUI

struct PreferenceView: View {
    @EnvironmentObject var navigationState: MyNavigationState
    @EnvironmentObject var preferenceController: PreferenceController
    
    @State var isJiraEnabled: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            MyNavigationBar(title: "Preference") {
                navigationState.popTo(id: nil)
            }
            VStack {
                MyNavigationLink(id: "jira-authentication-view", focusColor: .clear, autoRedirect: false) {
                    HStack {
                        Text("Jira Integration")
                        Spacer()
                        Toggle(isOn: $isJiraEnabled) {
                        }
                        .onChange(of: isJiraEnabled, perform: { jiraEnabled in
                            if jiraEnabled && !preferenceController.hasJiraAuthKey() {
                                navigationState.push(id: "jira-authentication-view")
                            } else if !jiraEnabled && preferenceController.hasJiraAuthKey() {
                                preferenceController.clearJiraAuth()
                            }
                        })
                        .toggleStyle(.switch)
                    }
                } destination: {
                    JiraAuthenticationView()
                }
                
                
                Divider()
                
                MyNavigationLink(id: "about") {
                    Text("About")
                } destination: {
                    AboutView()
                }


                
                
            }.padding(defaultPadding)
        }
        .onAppear {
            isJiraEnabled = preferenceController.hasJiraAuthKey()
        }
    }
}

struct PreferenceView_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceView()
            .environmentObject(MyNavigationState())
            .environmentObject(PreferenceController.instance)
    }
}
