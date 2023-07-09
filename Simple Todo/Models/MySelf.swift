//
//  MySelf.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 09/07/23.
//

import Foundation

class MySelf: Codable, Identifiable {
    var accountId: String?
    var emailAddress: String?
    var avatarUrls: [String: String]?
    var displayName: String?
    
    convenience init(from data: Data) {
        self.init()
        
        guard let json = String(data: data, encoding: .utf8), let result = decode(self, from: json) else {
            return
        }
        
        self.accountId = result.accountId
        self.emailAddress = result.emailAddress
        self.avatarUrls = result.avatarUrls
        self.displayName = result.displayName
    }
}
