//
//  Untitled.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 21/04/25.
//

import SwiftUI
import WidgetKit

struct SimpleTodoWidget: Widget {
    let kind: String = "SimpleTodoWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: SimpleTodoWidgetIntent.self,
            provider: SimpleTodoTimelineProvider()) { entry in
                SimpleTodoWidgetEntryView(entry: entry)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .containerBackground(.thickMaterial, for: .widget)
                
            }
    }
}
