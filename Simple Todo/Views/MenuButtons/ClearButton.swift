//
//  ClearButton.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 30/06/23.
//

import SwiftUI

struct ClearButton: View {
    @EnvironmentObject var taskDelegate: TaskDelegate
    @State var isHovered: Bool = false
    
    var body: some View {
        MyMenuButton { _ in
            AnyView(
                Text("Delete All")
            )
        } callback: {
            taskDelegate.clearTask()
        }
    }
}

struct ClearButton_Previews: PreviewProvider {
    static var previews: some View {
        ClearButton()
            .environmentObject(TaskDelegate.instance)
    }
}
