//
//  TaskModel.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 29/06/23.
//

import Foundation

class TaskModel: Codable, Identifiable {
    var id: String
    var title: String
    var timestamp: String
    var status: TaskStatus
    var jiraCard: String? = nil
    
    init(title: String, timestamp: String) {
        self.id = UUID().uuidString
        self.title = title
        self.timestamp = timestamp
        self.status = .created
    }
    
    func update(status: TaskStatus) {
        self.status = status
    }
    
    func update(title: String) {
        self.title = title
    }
    
    func update(timestamp: String) {
        self.timestamp = timestamp
    }
    
    func asDate() -> Date? {
        guard let originDate = ISO8601DateFormatter().date(from: timestamp) else {
            return nil
        }
        
        return originDate
    }
    
    func formattedDate() -> String {
        return timestamp.asFormattedDate()
    }
    
    func isOverdue() -> Bool {
        guard let date = asDate() else {
            return false
        }
        
        return date.timeIntervalSinceNow.isLess(than: 0.0)
    }
    
    func setJiraCard(_ card: String) {
        if let url = URL(string: card) {
            jiraCard = url.lastPathComponent
            return
        }
        jiraCard = card
    }
}

enum TaskStatus: Codable {
    case created
    case completed
}
