//
//  MyMenuButton.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 01/07/23.
//

import SwiftUI

struct MyMenuButton: View {
    @State var isHovered: Bool = false
    @ViewBuilder var label: AnyView
    var callback: () -> Void
    var expanded: Bool = true
    
    init(expanded: Bool = true,
         label: ()->  some View,
         callback: @escaping () -> Void) {
        self.label = AnyView(label())
        self.callback = callback
        self.expanded = expanded
    }
    
    
    var body: some View {
        Button{
            callback()
        }
        label: {
            HStack{
                HStack {
                    label
                    if expanded {
                        Spacer()
                    }
                }.padding(defaultPadding)
                    .contentShape(Rectangle())
            }
        }
        .background(
            isHovered ? .blue : .clear
        )
        .buttonStyle(.plain)
        .onHover { hovered in
            isHovered = hovered
        }
    }
}

struct MyMenuButton_Previews: PreviewProvider {
    static var previews: some View {
        MyMenuButton {
            Text("This is button")
        } callback: {
            
        }

    }
}
