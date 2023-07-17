//
//  JiraCardDetail.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 01/07/23.
//

import SwiftUI

class JiraCardDetail: Codable {
    var key: String?
    var summary: String?
    var description: String?
    var labels: [String]?
    var reporterName: String?
    var reporterAvatar: String?
    var status: String?
    var statusId: String?
    var transitionId: String?
    var priority: String?
    var dueDate: String?
    var createdAt: String?
    var parentId: String?
    var parentSummary: String?
    var issueType: String?
    var assignee: String?
    var assigneeEmail: String?
    var assigneeAvatar: String?
    
    func browseUrl(host: String) -> String {
        guard let key = key else {
            return ""
        }
        return "\(host)/browse/\(key)"
    }
    
    convenience init(from data: Data) {
        self.init()
        guard let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let fields = dict["fields"] as? [String: Any] else {
            return
        }
        
        self.key = dict["key"] as? String
        
        self.summary = fields["summary"] as? String
        self.description = fields["description"] as? String
        self.labels = fields["labels"] as? [String]
        if let reporter = fields["reporter"] as? [String: Any], let reporterName = reporter["displayName"] as? String {
            self.reporterName = reporterName
            if let avatarUrls = reporter["avatarUrls"] as? [String: String] {
                self.reporterAvatar = avatarUrls["16x16"]
            }
        }
        if let status = fields["status"] as? [String: Any], let statusName = status["name"] as? String, let statusId = status["id"] as? String {
            self.status = statusName
            self.statusId = statusId
        }
        if let priority = fields["priority"] as? [String: Any], let priorityName = priority["name"] as? String {
            self.priority = priorityName
        }
        self.dueDate = fields["duedate"] as? String
        self.createdAt = fields["createad"] as? String
        if let parent = fields["parent"] as? [String: Any], let parentKey = parent["key"] as? String {
            self.parentId = parentKey
            if let parentFields = parent["fields"] as? [String: Any], let parentSummary = parentFields["summary"] as? String {
                self.parentSummary = parentSummary
            }
        }
        if let issueType = fields["issuetype"] as? [String: Any], let issueTypeId = issueType["id"] as? String {
            self.issueType = issueTypeId
        }
        if let assignee = fields["assignee"] as? [String: Any], let assigneMail = assignee["emailAddress"] as? String, let assigneeName = assignee["displayName"] as? String {
            self.assignee = assigneeName
            self.assigneeEmail = assigneMail
            if let avatarUrls = assignee["avatarUrls"] as? [String: String] {
                assigneeAvatar = avatarUrls["16x16"]
            }
        }
    }
}
