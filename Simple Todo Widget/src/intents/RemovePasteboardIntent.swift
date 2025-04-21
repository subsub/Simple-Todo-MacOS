//
//  RemovePasteboardIntent.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 21/04/25.
//

import SwiftUI
import WidgetKit
import AppIntents

struct RemovePasteboardIntent: WidgetConfigurationIntent {
    
    static var title: LocalizedStringResource = "Copy Pasteboard"
    static var description: IntentDescription = .init("Select Pasteboard item to copy")
    
    @Parameter(title: "pasteboard", default: "Pasteboard item")
    var pasteboard: String
    
    init(pasteboard: String) {
        self.pasteboard = pasteboard
    }
    
    init() {
        
    }
    
    func perform() async throws -> some IntentResult {
        guard let userDefaults = UserDefaults(suiteName: "group.com.subkhansarif.SimpleTodo") else {
            return .result()
        }
        
        removePasteboard(userDefaults: userDefaults)
        NotificationCenter.default.post(name: Notification.Name(pasteboardUpdateName), object: true)
        return .result()
    }
    
    private func load(userDefaults: UserDefaults) -> UserPreference {
        let rawPreferences = userDefaults.string(forKey: "user-preference") ?? "{}"
        let preference: UserPreference = UserPreference()
        let result = decode(preference, from: rawPreferences) ?? UserPreference()
        return result
    }
    
    func getPasteboards(userDefaults: UserDefaults) -> [String] {
        let preference = load(userDefaults: userDefaults)
        guard let pref = preference.preferences[PrefKey.pasteboardKey], case PrefValue.stringArray(let value) = pref else {
            return []
        }
        return value
    }
    
    func removePasteboard(userDefaults: UserDefaults) {
        var pasteboards = getPasteboards(userDefaults: userDefaults)
        guard let index = pasteboards.firstIndex(of: pasteboard) else {
            return
        }
        pasteboards.remove(at: index)
        var preference = load(userDefaults: userDefaults)
        preference.preferences[PrefKey.pasteboardKey] = PrefValue.stringArray(pasteboards)
        guard let rawPreference = encode(data: preference) else {
            return
        }
        
        userDefaults.set(rawPreference, forKey: "user-preference")
        userDefaults.synchronize()
    }
}
