//
//  PreferenceView.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 01/07/23.
//

import SwiftUI
import simple_navigation

struct PreferenceView: View {
    @EnvironmentObject var navigationState: SimpleNavigationState
    @EnvironmentObject var preferenceController: PreferenceController
    
    @State var isJiraEnabled: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            SimpleNavigation.bar(title: "Preference") {
                navigationState.popTo(id: nil)
            }
            VStack {
                SimpleNavigation.link(id: "jira-authentication-view", focusColor: .clear, autoRedirect: false) {
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
                
                SimpleNavigation.link(id: "about") {
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
            .environmentObject(SimpleNavigation.state())
            .environmentObject(PreferenceController.instance)
    }
}
