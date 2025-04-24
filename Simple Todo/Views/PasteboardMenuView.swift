//
//  PasteboardMenuView.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 22/04/25.
//


import SwiftUI

struct PasteboardMenuView: View {
    enum Field : Hashable {
        case keyword
    }
    
    @EnvironmentObject var navigationState: MyNavigationState
    @EnvironmentObject var preferenceController: PreferenceController
    @EnvironmentObject var appDelegate: AppDelegate
    @State var hoveredValue: String? = nil
    @State var pasteboards: [String] = []
    @State var shouldShowToast: Bool = false
    @State var toastMessage: String = ""
    @State var keyword: String = ""
    @State var isEditing: Bool = false
    @State var trashHovered: Bool = false
    @FocusState var focusedState: Field?
    @State var timer: Timer?
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                HStack {
                    Button {
                        navigationState.popTo(id: nil)
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.blue)
                            .padding(.init(top: 2, leading: 10, bottom: 0, trailing: 0))
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    TextField("", text: $keyword)
                        .onSubmit {
                            if keyword.isEmpty {
                                pasteboards = preferenceController.getPasteboards()
                            } else {
                                pasteboards = preferenceController.searchPasteboards(keyword)
                            }
                            timer?.invalidate()
                            timer = nil
                        }
                        .focused($focusedState, equals: .keyword)
                        .onChange(of: keyword) {
                            if timer != nil {
                                timer!.invalidate()
                            }
                            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { timer in
                                if keyword.isEmpty {
                                    pasteboards = preferenceController.getPasteboards()
                                } else {
                                    pasteboards = preferenceController.searchPasteboards(keyword)
                                }
                            })
                            withAnimation(.easeInOut(duration: 0.1)) {
                                isEditing = !keyword.isEmpty
                            }
                        }
                        .textFieldStyle(.plain)
                        .padding(defaultPadding)
                        .background(.ultraThinMaterial)
                        .cornerRadius(4)
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(!isEditing ? ColorTheme.instance.textButtonDefault.opacity(0.2) : ColorTheme.instance.textButtonDefault, lineWidth: 0.5))
                        .padding(.init(top: 8, leading: 2, bottom: 4, trailing: 0))
                        .frame(maxWidth: .infinity)
                        .overlay(alignment: .leading) {
                            if !isEditing {
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                    Text("Search Pasteboards")
                                }
                                .padding(.init(top: 10, leading: 10, bottom: 6, trailing: 0))
                                .foregroundStyle(.blue)
                            }
                        }
                    Button {
                        preferenceController.setPasteboards([])
                        pasteboards = preferenceController.getPasteboards()
                    } label: {
                        Text("Clear")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.init(top: 4, leading: 0, bottom: 0, trailing: 8))

                }
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
                                }
                                .background(hoveredValue == value ? .blue : .clear)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                                
                                Button {
                                    preferenceController.removeFromPasteboards(value)
                                    pasteboards = preferenceController.getPasteboards()
                                } label: {
                                    Image(systemName: "trash")
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding(.init(top: 0, leading: 8, bottom: 0, trailing: 4))
                                .foregroundStyle(hoveredValue == value && trashHovered ? .blue: .secondary)
                                .opacity(hoveredValue == value ? 1 : 0)
                                .onHover { hovered in
                                    trashHovered = hovered
                                }
                            }
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
            focusedState = .keyword
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
