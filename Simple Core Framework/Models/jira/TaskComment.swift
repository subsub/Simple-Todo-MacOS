//
//  TaskComment.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 04/07/23.
//

import Foundation

class TaskComment: Codable, Identifiable, Equatable {
    var id: String
    var author: CommentAuthor?
    var body: String?
    var createdAt: String?
    var updatedAuthor: CommentAuthor?
    
    static func from(_ data: Data) -> [TaskComment] {
        let result: [TaskComment] = []
        
        guard let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            return []
        }
        
        if let commentsMap = dict["comments"] as? [[String: Any]], let commentsData = try? JSONSerialization.data(withJSONObject: commentsMap), let commentsStr = String(data: commentsData, encoding: .utf8), let comments = decode(result, from: commentsStr) {
            return comments
        }
        
        return []
    }
    
    static func == (lhs: TaskComment, rhs: TaskComment) -> Bool {
        return lhs.id == rhs.id
    }
    
}

class CommentAuthor: Codable, Identifiable {
    var emailAddress: String?
    var avatarUrls: [String: String]?
    var displayName: String?
    var active: Bool?
}
