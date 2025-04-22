//
//  SimpleTodoWidgetEntry.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 21/04/25.
//

import WidgetKit
import SwiftUI

struct SimpleTodoWidgetEntry: TimelineEntry {
    let date: Date
    let pasteboards: [String]
    let hasMore: Int
    let family: WidgetFamily
}
