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
                Button(intent: RemovePasteboardIntent(pasteboard: "-")) {
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
                    Button(intent: RemovePasteboardIntent(pasteboard: pasteboard)) {
                        HStack {
                            Text(pasteboard)
                                .lineLimit(1)
                                .truncationMode(.tail)
                            Spacer()
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(intent: RemovePasteboardIntent(pasteboard: pasteboard)) {
                        Image(systemName: "trash")
                    }
                    .buttonStyle(PlainButtonStyle())
                    .foregroundStyle(.secondary)
                }
            }
            if entry.hasMore > 0 {
                Button(intent: RemovePasteboardIntent(pasteboard: "-")) {
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
