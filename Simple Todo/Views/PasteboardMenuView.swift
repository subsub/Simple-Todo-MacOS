//
//  PasteboardMenuView.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 22/04/25.
//


import SwiftUI

struct PasteboardMenuView: View {
    @EnvironmentObject var preferenceController: PreferenceController
    @EnvironmentObject var appDelegate: AppDelegate
    @State var hoveredValue: String? = nil
    @State var pasteboards: [String] = []
    @State var shouldShowToast: Bool = false
    @State var toastMessage: String = ""
    
    var body: some View {
        VStack {
            MyToast(isShowing: $shouldShowToast, title: toastMessage, type: .Success)
                .frame(height: shouldShowToast ? 50 : 0)
            ForEach(pasteboards.reversed(), id: \.self) { value in
                HStack {
                    Button {
                        copy(value)
                    } label: {
                        Text(value)
                            .lineLimit(2)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.init(top: 2, leading: 4, bottom: 2, trailing: 4))
                    .foregroundStyle(hoveredValue == value ? .white : .primary)
                    
                    Spacer()
                    
                    Button {
                        preferenceController.removeFromPasteboards(value)
                        pasteboards = preferenceController.getPasteboards()
                    } label: {
                        Image(systemName: "trash")
                    }
                    .buttonStyle(PlainButtonStyle())
                    .foregroundStyle(.secondary)
                    
                }
                .background(hoveredValue == value ? .blue : .clear)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .padding(.init(top: 2, leading: 2, bottom: 2, trailing: 2))
                .onHover { hovered in
                    hoveredValue = value
                }
            }
        }
        .padding(.init(top: 2, leading: 8, bottom: 2, trailing: 8))
        .onAppear {
            pasteboards = preferenceController.getPasteboards()
        }
        .onReceive(preferenceController.$preference) { _ in
            pasteboards = preferenceController.getPasteboards()
        }
    }
    
    func copy(_ clipboard: String) {
        appDelegate.pasteboard.prepareForNewContents()
        appDelegate.pasteboard.setString(clipboard, forType: .string)
        withAnimation {
            toastMessage = "Copied ✅"
            shouldShowToast = true
        }
    }
}
