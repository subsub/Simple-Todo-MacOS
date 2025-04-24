//
//  Clipboards.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 18/04/25.
//

import SwiftUI

struct Pasteboards: View {
    @EnvironmentObject var preferenceController: PreferenceController
    @EnvironmentObject var appDelegate: AppDelegate
    @State var pasteboards: [String] = []
    @State var isHovered: Bool = false
    @State var shouldShowToast: Bool = false
    @State var toastMessage: String = ""
    
    var body: some View {
        MyNavigationLink(id: "pasteboards", colorDelegate: ColorTheme.instance) {
            HStack {
                Image(systemName: "list.clipboard.fill")
                    .foregroundStyle(isHovered ? .white : .blue)
                Text("Pasteboards (\(pasteboards.count))")
            }
        } destination: {
            PasteboardMenuView()
        }
        .onHover { hovered in
            isHovered = hovered
        }
        .onAppear {
            pasteboards = preferenceController.getPasteboards()
        }
        .onReceive(preferenceController.$preference) { _ in
            pasteboards = preferenceController.getPasteboards()
        }
    }
    
    var emptyClipboards: some View {
        Text("Copied items will appear here.")
    }
    
    func clearPasteboards() {
        preferenceController.setPasteboards([])
        withAnimation {
            toastMessage = "Cleared ✅"
            shouldShowToast = true
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
