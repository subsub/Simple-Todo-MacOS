//
//  PreferenceController.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 01/07/23.
//

import SwiftUI

class PreferenceController: CodableUtil, ObservableObject {
    static let instance = PreferenceController()
    
    @AppStorage("user-preference") var rawPreferences: String = ""
    @Published var preference: UserPreference = UserPreference()
    
    override init() {
        super.init()
        self.load()
    }
    
    func hasJiraAuthKey() -> Bool {
        preference.jiraAuthenticationKey != nil && !preference.jiraAuthenticationKey!.isEmpty
    }
    
    func saveJiraAuth(username: String, apiKey: String, host: String) {
        let base64 = "\(username):\(apiKey)".toBase64()
        preference.jiraAuthenticationKey = base64
        preference.jiraServerUrl = host
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