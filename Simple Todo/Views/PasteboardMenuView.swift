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
        ZStack(alignment: .top) {
            VStack {
                HStack {
                    Image(systemName: "list.clipboard.fill")
                    Text("Pasteboards")
                }
                .padding(.init(top: 8, leading: 0, bottom: 0, trailing: 0))
                .foregroundStyle(.blue)
                Rectangle()
                    .fill(.secondary.opacity(0.1))
                    .frame(height: 1)
                    .padding(.init(top: 0, leading: 4, bottom: 0, trailing: 4))
                ScrollView {
                    VStack {
                        if pasteboards.isEmpty {
                            Text("Copied items will appear here.")
                        }
                        ForEach(pasteboards.reversed(), id: \.self) { value in
                            HStack {
                                Button {
                                    copy(value)
                                } label: {
                                    Text(value)
                                        .lineLimit(2)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding(.init(top: 4, leading: 4, bottom: 4, trailing: 4))
                                .foregroundStyle(hoveredValue == value ? .white : .primary)
                                
                                Spacer()
                                
                                Button {
                                    preferenceController.removeFromPasteboards(value)
                                    pasteboards = preferenceController.getPasteboards()
                                } label: {
                                    Image(systemName: "trash")
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 4))
                                .foregroundStyle(hoveredValue == value ? .white : .secondary)
                                
                            }
                            .background(hoveredValue == value ? .blue : .clear)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                            .onHover { hovered in
                                hoveredValue = value
                            }
                        }
                    }
                    .padding(.init(top: 0, leading: 8, bottom: 2, trailing: 8))
                }
                
            }
            
            MyToast(isShowing: $shouldShowToast, title: toastMessage, type: .Success)
                .frame(height: shouldShowToast ? 50 : 0)
                .padding()
        }
        .padding(.init(top: 0, leading: 0, bottom: 4, trailing: 0))
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


struct PasteboardMenuView_Previews: PreviewProvider {
    static var previews: some View {
        PasteboardMenuView()
            .environmentObject(PreferenceController.instance)
    }
}
