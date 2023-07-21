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
        MyMenuButton { _ in
            AnyView(
                Text("Quit")
            )
        } callback: {
            NSApplication.shared.terminate(nil)
        }
    }
}

struct QuitButton_Previews: PreviewProvider {
    static var previews: some View {
        QuitButton()
    }
}
