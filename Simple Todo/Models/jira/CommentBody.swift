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
    var text: String?
    var type: String
    var marks: [Mark]?
    var attrs: Attrs?
    
    init(type: String, text: String? = nil, marks: [Mark]? = nil, attrs: Attrs? = nil) {
        self.text = text
        self.type = type
        self.marks = marks
        self.attrs = attrs
    }
}

class Mark: Codable {
    var type: String
    
    init(type: String) {
        self.type = type
    }
}

class Attrs: Codable {
    var url: String?
    
    init(url: String? = nil) {
        self.url = url
    }
}

extension NewCommentData {
    convenience init(raw comment: String) {
        let splitteds = comment.splitLinks()
        var contents: [Content] = []
        for splitted in splitteds {
            contents.append(
                Content(
                    type: splitted.isLink() ? "inlineCard" : "text",
                    text: splitted.isLink() ? nil : splitted,
                    attrs: splitted.isLink() ? Attrs(url: splitted) : nil
                )
            )
        }
        self.init(
            body: CommentBody(
                content: [
                    CommentContent(
                        content: contents,
                        type: "paragraph")
                ],
                type: "doc",
                version: 1
            )
        )
    }
}
