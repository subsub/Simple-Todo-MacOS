//
//  Simple_Todo_Widget.swift
//  Simple Todo Widget
//
//  Created by Subkhan Sarif on 20/04/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    let userDefaults = UserDefaults(suiteName: "group.com.subkhansarif.SimpleTodo")
    
    private func load() -> UserPreference {
        let rawPreferences = userDefaults?.string(forKey: "user-preference") ?? "{}"
        var preference: UserPreference = UserPreference()
        let result = decode(preference, from: rawPreferences) ?? UserPreference()
        print(">> rawPreferences: \(rawPreferences), preference: \(preference)")
        return result
    }
    
    func placeholder(in context: Context) -> PasteboardEntry {
        PasteboardEntry(date: Date(), pasteboards: ["Paste item 1", "Paste item 2"])
    }
    
    func getPasteboards() -> [String] {
        let preference = load()
        guard let pref = preference.preferences[PrefKey.pasteboardKey], case PrefValue.stringArray(let value) = pref else {
            return []
        }
        return value
    }
    
    func getSnapshot(in context: Context, completion: @escaping (PasteboardEntry) -> ()) {
        let pasteboards = getPasteboards()
        let entry = PasteboardEntry(date: Date(), pasteboards: pasteboards)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let pasteboards = getPasteboards()
        var entries: [PasteboardEntry] = [PasteboardEntry(date: Date(), pasteboards: pasteboards)]
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    //    func relevances() async -> WidgetRelevances<Void> {
    //        // Generate a list containing the contexts this widget is relevant in.
    //    }
}

struct PasteboardEntry: TimelineEntry {
    let date: Date
    let pasteboards: [String]
}

struct Simple_Todo_WidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "list.clipboard.fill")
                    .foregroundStyle(.blue)
                Text("Pasteboards")
                    .foregroundStyle(.blue)
            }
            Divider()
            ForEach(entry.pasteboards, id: \.self) { pasteboard in
                HStack {
                    Button {
                        copy(pasteboard)
                    } label: {
                        HStack {
                            Text(pasteboard)
                            Spacer()
                        }
                    }
                    Image(systemName: "trash")
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
        }
        .frame(alignment: .topLeading)
    }
    
    
    func copy(_ clipboard: String) {
        NSPasteboard.general.prepareForNewContents()
        NSPasteboard.general.setString(clipboard, forType: .string)
//        appDelegate.pasteboard.prepareForNewContents()
//        appDelegate.pasteboard.setString(clipboard, forType: .string)
//        withAnimation {
//            toastMessage = "Copied ✅"
//            shouldShowToast = true
//        }
    }
}

struct Simple_Todo_Widget: Widget {
    let kind: String = "Simple_Todo_Widget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: Provider()) { entry in
                if #available(macOS 14.0, *) {
                    Simple_Todo_WidgetEntryView(entry: entry)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .containerBackground(.thickMaterial, for: .widget)
                } else {
                    Simple_Todo_WidgetEntryView(entry: entry)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                        .background(.thickMaterial)
                }
            }
            .configurationDisplayName("Simple Todo Pasteboards")
            .description("Access Pasteboards from your Mac desktop")
    }
}
