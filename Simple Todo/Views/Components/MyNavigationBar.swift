//
//  MyNavigationBar.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 30/06/23.
//

import SwiftUI

struct MyNavigationBar: View {
    var title: String
    var titleView: AnyView?
    var onBackButton: () -> Void
    var confirmText: String?
    var onConfirmButton: (() -> Void)?
    var isConfirmButtonEnabled: Bool = true
    var bottomPadding: EdgeInsets?
    
    init(
        title: String? = nil,
        confirmText: String? = nil,
        confirmButtonEnabled: Bool = true,
        bottomPadding: EdgeInsets? = nil,
        _ onBackButton: @escaping () -> Void,
        onConfirmButton: (() -> Void)? = nil) {
            self.title = title ?? ""
            self.onBackButton = onBackButton
            self.onConfirmButton = onConfirmButton
            self.confirmText = confirmText
            self.isConfirmButtonEnabled = confirmButtonEnabled
            self.bottomPadding = bottomPadding
        }
    
    init(
        @ViewBuilder title titleView: @escaping () -> some View,
        confirmText: String? = nil,
        confirmButtonEnabled: Bool = true,
        bottomPadding: EdgeInsets? = nil,
        onBackButton: @escaping () -> Void,
        onConfirmButton: (() -> Void)? = nil) {
            self.title = ""
            self.titleView = AnyView(titleView())
            self.onBackButton = onBackButton
            self.onConfirmButton = onConfirmButton
            self.confirmText = confirmText
            self.isConfirmButtonEnabled = confirmButtonEnabled
            self.bottomPadding = bottomPadding
        }
    
    var body: some View {
        HStack {
            Button {
                
                onBackButton()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(.blue)
            }
            .buttonStyle(.plain)
            
            Spacer()
            
            if titleView != nil {
                titleView
                    .frame(maxHeight: 24, alignment: .topLeading)
            } else {
                Text(title)
                    .frame(maxHeight: 24, alignment: .topLeading)
            }
            
            Spacer()
            
            if confirmText != nil {
                Button {
                    onConfirmButton?()
                } label: {
                    Text(confirmText!)
                        .foregroundColor(isConfirmButtonEnabled ? .blue : .gray)
                }
                .buttonStyle(.plain)
                .disabled(!isConfirmButtonEnabled)
            }
        }
        .frame(height: 24, alignment: .topLeading)
        .padding(bottomPadding ?? EdgeInsets(top: 4, leading: 8, bottom: 0, trailing: 8))
    }
}

struct MyNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        MyNavigationBar(title: "Create new task"){}
    }
}
