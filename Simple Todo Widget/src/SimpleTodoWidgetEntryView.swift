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
                Text("Pasteboards (\(entry.totalCount))")
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
            if entry.family == .systemExtraLarge {
                ExtraLargeWidgetList(pasteboards: entry.pasteboards.reversed())
            } else {
                ForEach(entry.pasteboards.reversed(), id: \.self) { pasteboard in
                    HStack {
                        Button(intent: SimpleTodoWidgetIntent(pasteboard: pasteboard, intent: intentCopy)) {
                            HStack {
                                Text(pasteboard.replacing(/\s+/, with: ""))
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
            }
            if entry.hasMore > 0 {
                Button(intent: SimpleTodoWidgetIntent(pasteboard: seeMoreConstant, intent: intentSeeMore)) {
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

struct ExtraLargeWidgetList: View {
    let pasteboards: [String]
    let columnCount: Int = 12
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(spacing: 6) {
                ForEach(0..<firstColumnCount(), id: \.self) { index in
                    HStack {
                        Button(intent: SimpleTodoWidgetIntent(pasteboard: pasteboards[index], intent: intentCopy)) {
                            HStack {
                                Text(pasteboards[index].replacing(/\s+/, with: ""))
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                Spacer()
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Button(intent: SimpleTodoWidgetIntent(pasteboard: pasteboards[index], intent: intentRemove)) {
                            Image(systemName: "trash")
                        }
                        .buttonStyle(PlainButtonStyle())
                        .foregroundStyle(.secondary)
                    }
                }
            }
            if shouldHaveTwoColumns() {
                VStack(spacing: 6) {
                    ForEach(columnCount..<pasteboards.count, id: \.self) { index in
                        HStack {
                            Button(intent: SimpleTodoWidgetIntent(pasteboard: pasteboards[index], intent: intentCopy)) {
                                HStack {
                                    Text(pasteboards[index].replacing(/\s+/, with: ""))
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                    Spacer()
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Button(intent: SimpleTodoWidgetIntent(pasteboard: pasteboards[index], intent: intentRemove)) {
                                Image(systemName: "trash")
                            }
                            .buttonStyle(PlainButtonStyle())
                            .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
    }
    
    func shouldHaveTwoColumns() -> Bool {
        return pasteboards.count > columnCount
    }
    
    func firstColumnCount() -> Int {
        if shouldHaveTwoColumns() {
            return columnCount
        } else {
            return pasteboards.count
        }
    }
}
