//
//  DeleteAllDoneButton.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 01/07/23.
//

import SwiftUI

struct DeleteAllDoneButton: View {
    @EnvironmentObject var taskDelegate: TaskDelegate
    @State var isHovered: Bool = false
    
    var body: some View {
        MyMenuButton { _ in
            AnyView(
                Text("Delete All Done")
            )
        } callback: {
            taskDelegate.deleteAllDone()
        }
    }
}

struct DeleteAllDoneButton_Previews: PreviewProvider {
    static var previews: some View {
        DeleteAllDoneButton()
            .environmentObject(TaskDelegate.instance)
    }
}
