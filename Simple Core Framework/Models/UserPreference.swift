//
//  UserPreference.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 01/07/23.
//

import Foundation

struct UserPreference: Codable {
    var jiraAuthenticationKey: String?
    var jiraServerUrl: String?
    var jiraEmail: String?
    var preferences: [PrefKey: PrefValue] = [:]
}

enum PrefKey: String, Codable {
    case isPasteboardsEnabledKey, pasteboardKey, unknown
    
    init(from decoder: any Decoder) {
        do {
            if let string = try? decoder.singleValueContainer().decode(String.self) {
                self = PrefKey(rawValue: string) ?? .unknown
                return
            }
        }
        self = .unknown
    }
}

enum PrefValue: Codable, Equatable {
    case int(Int), string(String), bool(Bool), stringArray([String])
}
