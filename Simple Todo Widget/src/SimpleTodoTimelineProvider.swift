//
//  SimpleTodoTimelineProvider.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 21/04/25.
//

import WidgetKit
import SwiftUI

struct SimpleTodoTimelineProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleTodoWidgetEntry {
        SimpleTodoWidgetEntry(date: Date(), pasteboards: ["Paste item 1", "Paste item 2"], hasMore: 0)
    }
    
    func snapshot(for configuration: SimpleTodoWidgetIntent, in context: Context) async -> SimpleTodoWidgetEntry {
        guard let userDefaults = UserDefaults(suiteName: "group.com.subkhansarif.SimpleTodo") else {
            return SimpleTodoWidgetEntry(date: Date(), pasteboards: ["Paste item 1", "Paste item 2"], hasMore: 0)
        }
        
        var pasteboards = configuration.getPasteboards(userDefaults: userDefaults)
        var hasMore = 0
        switch context.family {
        case .systemSmall:
            if pasteboards.count > 4 {
                hasMore = pasteboards.count - 4
            }
            pasteboards = Array(pasteboards.suffix(4))
        case .systemMedium:
            if pasteboards.count > 4 {
                hasMore = pasteboards.count - 4
            }
            pasteboards = Array(pasteboards.suffix(4))
        case .systemLarge:
            if pasteboards.count > 11 {
                hasMore = pasteboards.count - 11
            }
            pasteboards = Array(pasteboards.suffix(11))
        case .systemExtraLarge:
            if pasteboards.count > 20 {
                hasMore = pasteboards.count - 20
            }
            pasteboards = Array(pasteboards.suffix(20))
        @unknown default:
            break
        }
        let entry = SimpleTodoWidgetEntry(date: Date(), pasteboards: pasteboards, hasMore: hasMore)
        return entry
    }
    
    
    func timeline(for configuration: SimpleTodoWidgetIntent, in context: Context) async -> Timeline<SimpleTodoWidgetEntry> {
        guard let userDefaults = UserDefaults(suiteName: "group.com.subkhansarif.SimpleTodo") else {
            let entry = SimpleTodoWidgetEntry(date: Date(), pasteboards: ["Paste item 1", "Paste item 2"], hasMore: 0)
            return Timeline(entries: [entry], policy: .never)
        }
        
        
        var pasteboards = configuration.getPasteboards(userDefaults: userDefaults)
        var hasMore = 0
        switch context.family {
        case .systemSmall:
            if pasteboards.count > 4 {
                hasMore = pasteboards.count - 4
            }
            pasteboards = Array(pasteboards.suffix(4))
        case .systemMedium:
            if pasteboards.count > 4 {
                hasMore = pasteboards.count - 4
            }
            pasteboards = Array(pasteboards.suffix(4))
        case .systemLarge:
            if pasteboards.count > 11 {
                hasMore = pasteboards.count - 11
            }
            pasteboards = Array(pasteboards.suffix(11))
        case .systemExtraLarge:
            if pasteboards.count > 20 {
                hasMore = pasteboards.count - 20
            }
            pasteboards = Array(pasteboards.suffix(20))
        @unknown default:
            break
        }
        let entry = SimpleTodoWidgetEntry(date: Date(), pasteboards: pasteboards, hasMore: hasMore)
        let timeline = Timeline(entries: [entry], policy: .never)
        return timeline
    }
}
