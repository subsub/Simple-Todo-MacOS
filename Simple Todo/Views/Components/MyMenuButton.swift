//
//  MyMenuButton.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 01/07/23.
//

import SwiftUI

struct MyMenuButton: View {
    @State var isHovered: Bool = false
    @ViewBuilder var label: (_ isHovered: Bool) -> AnyView
    var callback: () -> Void
    var expanded: Bool = true
    var padding: EdgeInsets?
    
    init(expanded: Bool = true,
         padding: EdgeInsets? = EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4),
         label: @escaping (_ isHovered: Bool) -> AnyView,
         callback: @escaping () -> Void) {
        self.label = label
        self.callback = callback
        self.expanded = expanded
        self.padding = padding
    }
    
    
    var body: some View {
        Button{
            callback()
        }
        label: {
            HStack{
                HStack {
                    label(isHovered)
                        .foregroundColor(ColorTheme.instance.textDefault)
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
        .cornerRadius(4)
        .padding(padding ?? EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4))
        .buttonStyle(.plain)
        .onHover { hovered in
            isHovered = hovered
        }
    }
}

struct MyMenuButton_Previews: PreviewProvider {
    static var previews: some View {
        MyMenuButton { _ in
            AnyView(
                Text("This is button")
            )
        } callback: {
            
        }

    }
}
