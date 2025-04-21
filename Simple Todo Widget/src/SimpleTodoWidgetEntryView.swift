//
//  SimpleTodoWidgetEntryView.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 21/04/25.
//

import SwiftUI

struct SimpleTodoWidgetEntryView: View {
    var entry: SimpleTodoWidgetEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: "list.clipboard.fill")
                    .foregroundStyle(.blue)
                Text("Pasteboards")
                    .foregroundStyle(.blue)
                Spacer()
                Button(intent: SimpleTodoWidgetIntent(pasteboard: "", intent: intentClear)) {
                    Text("Clear")
                }
                .buttonStyle(PlainButtonStyle())
                .foregroundStyle(.secondary)
            }
            Divider()
            if entry.pasteboards.isEmpty {
                Text("Copied items will appear here.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
            ForEach(entry.pasteboards.reversed(), id: \.self) { pasteboard in
                HStack {
                    Button(intent: SimpleTodoWidgetIntent(pasteboard: pasteboard, intent: intentCopy)) {
                        HStack {
                            Text(pasteboard)
                                .lineLimit(1)
                                .truncationMode(.tail)
                            Spacer()
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(intent: SimpleTodoWidgetIntent(pasteboard: pasteboard, intent: intentRemove)) {
                        Image(systemName: "trash")
                    }
                    .buttonStyle(PlainButtonStyle())
                    .foregroundStyle(.secondary)
                }
            }
            if entry.hasMore > 0 {
                Button(intent: SimpleTodoWidgetIntent(pasteboard: "", intent: intentSeeMore)) {
                    Text("\(entry.hasMore) more...")
                        .font(.footnote)
                }
                .buttonStyle(PlainButtonStyle())
                .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .frame(alignment: .topLeading)
    }
}
