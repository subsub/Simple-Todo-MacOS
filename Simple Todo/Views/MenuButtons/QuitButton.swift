//
//  QuitButton.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 30/06/23.
//

import SwiftUI

struct QuitButton: View {
    @State var isHovered: Bool = false
    
    var body: some View {
        Button{
            NSApplication.shared.terminate(nil)
        }
        label: {
            HStack{
                HStack {
                    Text("Quit")
                    Spacer()
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

struct QuitButton_Previews: PreviewProvider {
    static var previews: some View {
        QuitButton()
    }
}
