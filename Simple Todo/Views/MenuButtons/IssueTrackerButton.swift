//
//  JiraTaskButton.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 04/07/23.
//

import SwiftUI

struct IssueTrackerButton: View {
    var body: some View {
        MyNavigationLink(id: "jira-tasks") {
            Text("Jira Tasks")
        } destination: {
            IssueTrackerListView()
        }
    }
}

struct IssueTrackerButton_Previews: PreviewProvider {
    static var previews: some View {
        IssueTrackerButton()
            .environmentObject(MyNavigationState())
    }
}
