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
        SimpleTodoWidgetEntry(date: Date(), totalCount: 2, pasteboards: ["Paste item 1", "Paste item 2"], hasMore: 0, family: context.family)
    }
    
    func snapshot(for configuration: SimpleTodoWidgetIntent, in context: Context) async -> SimpleTodoWidgetEntry {
        guard let userDefaults = UserDefaults(suiteName: PrefKeys.suiteName) else {
            return SimpleTodoWidgetEntry(date: Date(), totalCount: 2, pasteboards: ["Paste item 1", "Paste item 2"], hasMore: 0, family: context.family)
        }
        
        var pasteboards = configuration.getPasteboards(userDefaults: userDefaults)
        let totalCount = pasteboards.count
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
            if pasteboards.count > 24 {
                hasMore = pasteboards.count - 24
            }
            pasteboards = Array(pasteboards.suffix(24))
        @unknown default:
            break
        }
        let entry = SimpleTodoWidgetEntry(date: Date(), totalCount: totalCount, pasteboards: pasteboards, hasMore: hasMore, family: context.family)
        return entry
    }
    
    
    func timeline(for configuration: SimpleTodoWidgetIntent, in context: Context) async -> Timeline<SimpleTodoWidgetEntry> {
        guard let userDefaults = UserDefaults(suiteName: PrefKeys.suiteName) else {
            let entry = SimpleTodoWidgetEntry(date: Date(), totalCount: 2, pasteboards: ["Paste item 1", "Paste item 2"], hasMore: 0, family: context.family)
            return Timeline(entries: [entry], policy: .never)
        }
        
        
        var pasteboards = configuration.getPasteboards(userDefaults: userDefaults)
        let totalCount = pasteboards.count
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
            if pasteboards.count > 24 {
                hasMore = pasteboards.count - 24
            }
            pasteboards = Array(pasteboards.suffix(24))
        @unknown default:
            break
        }
        let entry = SimpleTodoWidgetEntry(date: Date(), totalCount: totalCount, pasteboards: pasteboards, hasMore: hasMore, family: context.family)
        let timeline = Timeline(entries: [entry], policy: .never)
        return timeline
    }
}
