//
//  ClearButton.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 30/06/23.
//

import SwiftUI

struct ClearButton: View {
    @EnvironmentObject var taskDelegate: UserDefaultsDelegates
    @State var isHovered: Bool = false
    
    var body: some View {
        Button{
            taskDelegate.clearTask()
        }
        label: {
            HStack{
                HStack {
                    Text("Delete All")
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

struct ClearButton_Previews: PreviewProvider {
    static var previews: some View {
        ClearButton()
    }
}
