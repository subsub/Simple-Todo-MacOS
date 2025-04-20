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
    @State var isPasteboardsEnabled: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            MyNavigationBar(title: "Preference") {
                navigationState.popTo(id: nil)
            }
            VStack {
                MyNavigationLink(id: "jira-authentication-view", focusable: false, autoRedirect: false) {
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
                
                
                MyNavigationLink(id: "pasteboards",
                                 focusable: false,
                                 autoRedirect: false) {
                    HStack {
                        Text("Pasteboards")
                        Spacer()
                        Toggle(isOn: $isPasteboardsEnabled) {
                        }
                        .onChange(of: isPasteboardsEnabled, perform: { isPasteboardsEnabled in
                            preferenceController.setPasteboardsEnabled(isPasteboardsEnabled)
                            if !isPasteboardsEnabled {
                                preferenceController.setPasteboards([])
                            }
                        })
                        .toggleStyle(.switch)
                    }
                } destination: {
                    EmptyView()
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
            isPasteboardsEnabled = preferenceController.isPasteboardsEnabled()
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
