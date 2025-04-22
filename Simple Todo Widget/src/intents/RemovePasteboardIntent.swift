//
//  SimpleTodoWidgetIntent.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 21/04/25.
//

import SwiftUI
import WidgetKit
import AppIntents

let intentClear = "clear"
let intentRemove = "remove"
let intentCopy = "copy"
let intentSeeMore = "seeMore"

struct SimpleTodoWidgetIntent: WidgetConfigurationIntent {
    
    static var title: LocalizedStringResource = "Copy Pasteboard"
    static var description: IntentDescription = .init("Select Pasteboard item to copy")
    
    @Parameter(title: "pasteboard", default: "Pasteboard item")
    var pasteboard: String
    @Parameter(title: "intent", default: "-")
    var intent: String
    
    init(pasteboard: String, intent: String) {
        self.pasteboard = pasteboard
        self.intent = intent
    }
    
    init() {
        
    }
    
    func perform() async throws -> some IntentResult {
        print(">> perform intent: \(intent)")
        guard let userDefaults = UserDefaults(suiteName: PrefKeys.suiteName) else {
            return .result()
        }
        
        switch intent {
        case intentCopy:
            copy()
        case intentRemove:
            removePasteboard(userDefaults: userDefaults)
        case intentClear:
            clear(userDefaults: userDefaults)
        case intentSeeMore:
            seeMore()
        default:
            break
        }
        return .result()
    }
    
    private func load(userDefaults: UserDefaults) -> UserPreference {
        let rawPreferences = userDefaults.string(forKey: PrefKeys.userPreferenceKey) ?? "{}"
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
        
        userDefaults.set(rawPreference, forKey: PrefKeys.userPreferenceKey)
        userDefaults.synchronize()
    }
    
    func copy() {
        let pasteboard: NSPasteboard = .general
        pasteboard.prepareForNewContents()
        pasteboard.setString(self.pasteboard, forType: .string)
    }
    
    func clear(userDefaults: UserDefaults) {
        var preference = load(userDefaults: userDefaults)
        preference.preferences[PrefKey.pasteboardKey] = PrefValue.stringArray([])
        guard let rawPreference = encode(data: preference) else {
            return
        }
        
        userDefaults.set(rawPreference, forKey: PrefKeys.userPreferenceKey)
        userDefaults.synchronize()
    }
    
    func seeMore() {
        print(">> see more")
        let pasteboard: NSPasteboard = .general
        pasteboard.prepareForNewContents()
        pasteboard.setString(self.pasteboard, forType: .string)
    }
}
