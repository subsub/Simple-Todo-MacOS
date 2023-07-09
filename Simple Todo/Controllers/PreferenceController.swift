//
//  PreferenceController.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 01/07/23.
//

import SwiftUI

class PreferenceController: ObservableObject {
    static let instance = PreferenceController()
    
    @AppStorage("user-preference") var rawPreferences: String = ""
    @Published var preference: UserPreference = UserPreference()
    
    init() {
        self.load()
    }
    
    func hasJiraAuthKey() -> Bool {
        preference.jiraAuthenticationKey != nil && !preference.jiraAuthenticationKey!.isEmpty
    }
    
    func getPreference(username: String, apiKey: String, host: String) -> UserPreference {
        let base64 = "\(username):\(apiKey)".toBase64()
        var preference = UserPreference()
        preference.jiraAuthenticationKey = base64
        preference.jiraServerUrl = "https://\(host).atlassian.net"
        preference.jiraEmail = username
        return preference
    }
    
    func saveJiraAuth(from preference: UserPreference) {
        self.preference = preference
        save()
    }
    
    func clearJiraAuth() {
        preference.jiraAuthenticationKey = nil
        save()
    }
    
    private func save() {
        guard let rawPreference = encode(data: preference) else {
            return
        }
        
        self.rawPreferences = rawPreference
    }
    
    private func load() {
        preference = decode(preference, from: rawPreferences) ?? preference
    }
}
