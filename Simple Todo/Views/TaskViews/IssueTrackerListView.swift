//
//  IssueTrackerListView.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 04/07/23.
//

import SwiftUI

struct IssueTrackerListView: View {
    @EnvironmentObject var navigationState: MyNavigationState
    @EnvironmentObject var jiraController: JiraController
    
    var body: some View {
        VStack {
            MyNavigationBar(title: "Issue Tracker") {
                navigationState.popTo(id: nil)
            }
            
            issueItem
        }
    }
    
    var issueItem: some View {
        HStack {
            Text("Created At")
            Text("Key")
            Text("Summary")
            Text("Status")
        }
    }
}

struct IssueTrackerListView_Previews: PreviewProvider {
    static var previews: some View {
        IssueTrackerListView()
            .environmentObject(MyNavigationState())
            .environmentObject(JiraController.instance)
    }
}
