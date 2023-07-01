//
//  DeleteAllDoneButton.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 01/07/23.
//

import SwiftUI

struct DeleteAllDoneButton: View {
    @EnvironmentObject var taskDelegate: UserDefaultsDelegates
    @State var isHovered: Bool = false
    
    var body: some View {
        Button{
            taskDelegate.deleteAllDone()
        }
        label: {
            HStack{
                HStack {
                    Text("Delete All Done")
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

struct DeleteAllDoneButton_Previews: PreviewProvider {
    static let taskDelegate = UserDefaultsDelegates()
    static var previews: some View {
        DeleteAllDoneButton()
            .environmentObject(taskDelegate)
    }
}
