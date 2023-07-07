//
//  AccountDetail.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 07/07/23.
//

import Foundation

class AccountDetail: Codable {
    var accountId: String?
    var accountType: String?
    var emailAddress: String?
    var avatarUrls: [String: String]?
    var displayName: String?
    var active: Bool?
    
    convenience init(from data: Data) {
        self.init()
        
        guard let json = String(data: data, encoding: .utf8), let result = decode(self, from: json) else {
            return
        }
        
        self.accountId = result.accountId
        self.accountType = result.accountId
        self.emailAddress = result.emailAddress
        self.avatarUrls = result.avatarUrls
        self.displayName = result.displayName
        self.active = result.active
    }
}
