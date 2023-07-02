//
//  JiraStatus.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 02/07/23.
//

import Foundation

class JiraTransition: Codable, Identifiable {
    var id: String
    var name: String
    var hasScreen: Bool
    var isGlobal: Bool
    var isInitial: Bool
    var isConditional: Bool
    var isLooped: Bool
    var to: TransitionTo
    
    init(id: String,
         name: String,
         hasScreen: Bool,
         isGlobal: Bool,
         isInitial: Bool,
         isConditional: Bool,
         isLooped: Bool,
         to: TransitionTo) {
        self.id = id
        self.name = name
        self.hasScreen = hasScreen
        self.isGlobal = isGlobal
        self.isInitial = isInitial
        self.isConditional = isConditional
        self.isLooped = isLooped
        self.to = to
    }
    
    static func from(_ data: Data) -> [JiraTransition] {
        var result: [JiraTransition] = []
        
        guard let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            return []
        }
        
        if let transitionsMap = dict["transitions"] as? [[String: Any]], let transitionData = try? JSONSerialization.data(withJSONObject: transitionsMap), let transitionStr = String(data: transitionData, encoding: .utf8), let transitions = decode(result, from: transitionStr) {
            return transitions
        }
        
        return []
    }
}

class TransitionTo: Codable, Identifiable {
    var id: String
    var name: String
    var statusCategory: StatusCategory
}

class StatusCategory: Codable, Identifiable {
    var id: Int
}
