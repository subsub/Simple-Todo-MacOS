//
//  String+extension.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 01/07/23.
//

import Foundation

extension String {
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    func asFormattedDate() -> String {
        guard let originDate = ISO8601DateFormatter().date(from: self) else {
            return ""
        }
        
        return originDate.formatted(date: .abbreviated, time: .shortened)
    }
}
