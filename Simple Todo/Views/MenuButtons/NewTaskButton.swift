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
            Text("New Task")
                .foregroundColor(ColorTheme.instance.textDefault)
        } destination: {
            NewTaskView()
        }
    }
}

struct NewTaskButton_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskButton()
            .environmentObject(MyNavigationState())
    }
}
