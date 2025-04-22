//
//  PreferenceController.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 01/07/23.
//

import SwiftUI
import WidgetKit

enum PreferenceEvent {
    case newPasteboardData(String), deletePasteboardData(String), none
}

class PrefKeys {
    static let userPreferenceKey = "user-preference"
    static let eventNotificationKey = "event-notification"
    static let suiteName = "group.com.subkhansarif.SimpleTodo"
}

class PreferenceController: ObservableObject {
    static let instance = PreferenceController()
    
    
    @AppStorage(PrefKeys.eventNotificationKey, store: UserDefaults(suiteName: PrefKeys.suiteName))
    var eventNotification: String = "" {
        didSet {
            print(">> eventNotification \(eventNotification)")
        }
    }
    var rawPreferences: String = ""
    @Published var preference: UserPreference = UserPreference()
    @Published var preferenceEvent: PreferenceEvent = .none
    
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
        preference.preferences = self.preference.preferences
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
        guard let userDefaults = UserDefaults(suiteName: PrefKeys.suiteName) else {
            return
        }
        userDefaults.set(rawPreference, forKey: PrefKeys.userPreferenceKey)
        userDefaults.synchronize()
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    private func load() {
        guard let userDefaults = UserDefaults(suiteName: PrefKeys.suiteName) else {
            return
        }
        rawPreferences = userDefaults.string(forKey: PrefKeys.userPreferenceKey) ?? ""
        preference = decode(preference, from: rawPreferences) ?? preference
    }
    
    func isPasteboardsEnabled() -> Bool {
        guard let pref = preference.preferences[PrefKey.isPasteboardsEnabledKey], case PrefValue.bool(let value) = pref else {
            return false
        }
        return value
    }
    
    func setPasteboardsEnabled(_ enabled: Bool) {
        preference.preferences[PrefKey.isPasteboardsEnabledKey] = PrefValue.bool(enabled)
        save()
    }
    
    func getPasteboards() -> [String] {
        let _pref = decode(preference, from: rawPreferences) ?? preference
        if _pref.preferences[PrefKey.pasteboardKey] != preference.preferences[PrefKey.pasteboardKey] {
            preference = _pref
        }
        guard let pref = preference.preferences[PrefKey.pasteboardKey], case PrefValue.stringArray(let value) = pref else {
            return []
        }
        return value
    }
    
    func setPasteboards(_ pasteboards: [String]) {
        guard isPasteboardsEnabled() else {
            return
        }
        preference.preferences[PrefKey.pasteboardKey] = PrefValue.stringArray(pasteboards)
        save()
    }
    
    func addToPasteboards(_ value: String) {
        var pasteboards = self.getPasteboards()
        if let index = pasteboards.firstIndex(of: value) {
            pasteboards.remove(at: index)
        }
        pasteboards.append(value)
        self.setPasteboards(pasteboards)
        self.preferenceEvent = .newPasteboardData(value)
    }
    
    func removeFromPasteboards(_ value: String) {
        var pasteboards = self.getPasteboards()
        if let index = pasteboards.firstIndex(of: value) {
            pasteboards.remove(at: index)
        }
        self.setPasteboards(pasteboards)
        self.preferenceEvent = .deletePasteboardData(value)
    }
    
    func reload() {
        self.load()
    }
}
