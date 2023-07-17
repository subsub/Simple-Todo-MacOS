//
//  MyJiraTaskItem.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 17/07/23.
//

import Foundation

class MyJiraTaskItem: Codable {
    var id: String?
    var key: String?
    var lastViewed: String?
    var issuetype: IssueType?
    var reporter: AccountDetail?
    var assignee: AccountDetail?
    var description: String?
    var summary: String?
    var project: ProjectDetail?
    var status: JiraCardStatus?
    
    
    convenience init(from data: Data) {
        self.init()
        
        guard let json = String(data: data, encoding: .utf8), let result = decode(self, from: json) else {
            return
        }
        
        self.id = result.id
        self.key = result.key
        self.lastViewed = result.lastViewed
        self.issuetype = result.issuetype
        self.reporter = result.reporter
        self.assignee = result.assignee
        self.description = result.description
        self.summary = result.summary
        self.project = result.project
        self.status = result.status
    }
    
    static func from(_ data: Data) -> [MyJiraTaskItem] {
        guard let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let issues = dict["issues"] as? [[String: Any]] else {
            return []
        }
        
        var result: [MyJiraTaskItem] = []
        for issue in issues {
            guard let issueDetail = issue["fields"] as? [String: Any], let issuesData = try? JSONSerialization.data(withJSONObject: issueDetail), let issuesStr = String(data: issuesData, encoding: .utf8), let item = decode(MyJiraTaskItem(), from: issuesStr) else {
                continue
            }
            
            item.key = issue["key"] as? String
            item.id = issue["id"] as? String
            result.append(item)
        }

        return result
    }
}

class IssueType: Codable {
    var iconUrl: String?
    var name: String?
    var id: String?
}

