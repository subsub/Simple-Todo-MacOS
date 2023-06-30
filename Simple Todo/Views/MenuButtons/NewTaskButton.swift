//
//  NewTaskButton.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 29/06/23.
//

import SwiftUI

struct NewTaskButton: View {
    @EnvironmentObject var navigationState: MyNavigationState
    
    var body: some View {
        MyNavigationLink(id: "new-task") {
            HStack {
                Text("New Task")
                Spacer()
//                    Text("⌘ N")
//                        .contrast(isHovered ? 1.0 : 0.1)
            }.padding(defaultPadding)
                .contentShape(Rectangle())
        } destination: {
            NewTaskView()
        }
    }
}

struct NewTaskButton_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskButton()
    }
}
