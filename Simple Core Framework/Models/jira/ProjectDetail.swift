//
//  ProjectDetail.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 17/07/23.
//

import Foundation

class ProjectDetail: Codable {
    var id: String?
    var key: String?
    var name: String?
    var projectTypeKey: String?
    var simplified: Bool?
    var avatarUrls: [String: String]?
}
