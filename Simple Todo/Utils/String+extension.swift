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
    
    func findAccountIdAndReplace(host: String, _ action: @escaping (String) async -> String?) async -> String {
        let pattern = #"\[~accountid:([a-zA-Z0-9]*)\]"#
        let regex = try! NSRegularExpression(pattern: pattern, options: .anchorsMatchLines)
        let stringRange = NSRange(location: 0, length: self.utf16.count)
        let matches = regex.matches(in: self, range: stringRange)
        var result: [[String]] = []
        var groups: [String] = []
        for match in matches {
            for rangeIndex in 1 ..< match.numberOfRanges {
                let nsRange = match.range(at: rangeIndex)
                guard !NSEqualRanges(nsRange, NSMakeRange(NSNotFound, 0)) else { continue }
                let string = (self as NSString).substring(with: nsRange)
                groups.append(string)
            }
            if !groups.isEmpty {
                result.append(groups)
            }
        }
        
        var finalResult = self
        for accountid in groups {
            guard let userEmail = await action(accountid) else {
                continue
            }
            finalResult = finalResult.replacing("[~accountid:\(accountid)]", with: "[@\(userEmail)](\(host)/jira/people/\(accountid))")
        }
        
        return finalResult
    }
    
    func findAndReplaceQuote() -> String {
        let pattern = #"\{quote\}(.*)\{quote\}"#
        let regex = try! NSRegularExpression(pattern: pattern, options: .anchorsMatchLines)
        let stringRange = NSRange(location: 0, length: self.utf16.count)
        let matches = regex.matches(in: self, range: stringRange)
        var result: [[String]] = []
        var groups: [String] = []
        for match in matches {
            for rangeIndex in 1 ..< match.numberOfRanges {
                let nsRange = match.range(at: rangeIndex)
                guard !NSEqualRanges(nsRange, NSMakeRange(NSNotFound, 0)) else { continue }
                let string = (self as NSString).substring(with: nsRange)
                groups.append(string)
            }
            if !groups.isEmpty {
                result.append(groups)
            }
        }
        
        var finalResult = self
        for quote in groups {
            finalResult = finalResult.replacing("{quote}\(quote){quote}", with: "> \(quote)")
        }
        
        return finalResult
    }
    
    func findAndReplaceLink() -> String {
        let pattern = #"\[([a-zA-Z0-9\:\/\.\-\?\=\&\_\%]*[^\]])\|([a-zA-Z0-9\:\/\.\-\?\=\&\_\%\|]*[^\]])\]"#
        let regex = try! NSRegularExpression(pattern: pattern, options: .anchorsMatchLines)
        let stringRange = NSRange(location: 0, length: self.utf16.count)
        let matches = regex.matches(in: self, range: stringRange)
        var finalResult = self
        for match in matches {
            var groups: [String] = []
            for rangeIndex in 1 ..< match.numberOfRanges {
                let nsRange = match.range(at: rangeIndex)
                guard !NSEqualRanges(nsRange, NSMakeRange(NSNotFound, 0)) else { continue }
                let string = (self as NSString).substring(with: nsRange)
                groups.append(string)
            }
            
            if groups.count >= 2 {
                finalResult = finalResult.replacing("[\(groups[0])|\(groups[1])]", with: "[\(groups[0])](\(groups[1]))")
            }
        }
        
        return finalResult.replacing("|smart-link", with: "")
    }
    
    func findAndReplaceCode() -> String {
        let pattern = #"\{\{([a-zA-Z0-9\W\D\s][^\}]*)\}\}"#
        let regex = try! NSRegularExpression(pattern: pattern, options: .anchorsMatchLines)
        let stringRange = NSRange(location: 0, length: self.utf16.count)
        let matches = regex.matches(in: self, range: stringRange)
        var finalResult = self
        for match in matches {
            var groups: [String] = []
            for rangeIndex in 1 ..< match.numberOfRanges {
                let nsRange = match.range(at: rangeIndex)
                guard !NSEqualRanges(nsRange, NSMakeRange(NSNotFound, 0)) else { continue }
                let string = (self as NSString).substring(with: nsRange)
                groups.append(string)
            }
            
            if groups.count >= 1 {
                finalResult = finalResult.replacing("{{\(groups[0])}}", with: "`\(groups[0])`")
            }
        }
        return finalResult
    }
}
