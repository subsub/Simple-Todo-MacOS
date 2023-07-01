//
//  JiraCardDetail.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 01/07/23.
//

import SwiftUI

class JiraCardDetail: CodableUtil, Codable {
    var summary: String?
    var description: String?
    var labels: [String]?
    var reporterName: String?
    var status: String?
    var priority: String?
    var dueDate: String?
    var createdAt: String?
    var parentId: String?
    var parentSummary: String?
    
    convenience init(from data: Data) {
        self.init()
        guard let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let fields = dict["fields"] as? [String: Any] else {
            return
        }
        
        self.summary = fields["summary"] as? String
        self.description = fields["description"] as? String
        self.labels = fields["labels"] as? [String]
        if let reporter = fields["reporter"] as? [String: Any], let reporterName = reporter["displayName"] as? String {
            self.reporterName = reporterName
        }
        if let status = fields["status"] as? [String: Any], let statusName = status["name"] as? String {
            self.status = statusName
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
    }
}
