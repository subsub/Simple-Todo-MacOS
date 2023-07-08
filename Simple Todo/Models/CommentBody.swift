//
//  CommentBody.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 08/07/23.
//

import Foundation

class NewCommentData: Codable {
    var body: CommentBody
//    var visibility: CommentVisibility?
    init(body: CommentBody) {
        self.body = body
    }
}

class CommentBody: Codable {
    var content: [CommentContent]
    var type: String
    var version: Int
    
    init(content: [CommentContent], type: String, version: Int) {
        self.content = content
        self.type = type
        self.version = version
    }
}

class CommentVisibility: Codable {
    var identifier: String
    var type: String
    var value: String
    
    init(identifier: String, type: String, value: String) {
        self.identifier = identifier
        self.type = type
        self.value = value
    }
}

class CommentContent: Codable {
    var content: [Content]
    var type: String
    
    init(content: [Content], type: String) {
        self.content = content
        self.type = type
    }
}

class Content: Codable {
    var text: String
    var type: String
    var marks: [Mark]?
    
    init(text: String, type: String) {
        self.text = text
        self.type = type
    }
}

class Mark: Codable {
    var type: String
    
    init(type: String) {
        self.type = type
    }
}
