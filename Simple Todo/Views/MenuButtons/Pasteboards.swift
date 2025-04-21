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
        VStack {
            MyToast(isShowing: $shouldShowToast, title: toastMessage, type: .Success)
                .frame(height: shouldShowToast ? 50 : 0)
            ControlGroup {
                Text("Select pasteboard to copy")
                Divider()
                if pasteboards.isEmpty {
                    emptyClipboards
                }
                ForEach(pasteboards.reversed(), id: \.self) { value in
                    Button {
                        copy(value)
                    } label: {
                        HStack {
                            //                            Image(systemName: "pin.fill")
                            //                                .padding(.trailing, 4)
                            ControlGroup {
                                Button {
                                    preferenceController.removeFromPasteboards(value)
                                    pasteboards = preferenceController.getPasteboards()
                                } label: {
                                    HStack {
                                        Text("Delete")
                                        Image(systemName: "trash")
                                    }
                                }
                            } label: {
                                Text(value)
                            }
                        }
                    }
                }
            } label: {
                Text("Pasteboards (\(pasteboards.count))")
            }
            .foregroundColor(isHovered ? ColorTheme.instance.staticWhite: ColorTheme.instance.textDefault)
            .onHover { hovered in
                isHovered = hovered
            }
            .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
            .background(isHovered ? .blue : .clear)
            .cornerRadius(4)
            .padding(EdgeInsets(top: -8, leading: 4, bottom: 0, trailing: 4))
            
            MyMenuButton { _ in
                AnyView(
                    Text("Clear Pasteboards")
                )
            } callback: {
                clearPasteboards()
            }
        }
        .controlGroupStyle(.menu)
        .menuStyle(BorderlessButtonMenuStyle())
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
