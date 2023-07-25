//
//  JiraTaskButton.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 04/07/23.
//

import SwiftUI
import simple_navigation

struct IssueTrackerButton: View {
    var body: some View {
        SimpleNavigation.link(id: "jira-tasks") {
            Text("Jira Tasks")
                .foregroundColor(ColorTheme.instance.textDefault)
        } destination: {
            IssueTrackerListView()
        }
    }
}

struct IssueTrackerButton_Previews: PreviewProvider {
    static var previews: some View {
        IssueTrackerButton()
            .environmentObject(SimpleNavigation.state())
    }
}
