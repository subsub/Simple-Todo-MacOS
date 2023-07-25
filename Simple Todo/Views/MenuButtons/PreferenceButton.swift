//
//  PreferenceButton.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 01/07/23.
//

import SwiftUI
import simple_navigation

struct PreferenceButton: View {
    var body: some View {
        SimpleNavigation.link(id: "preference") {
            Text("Preference")
        } destination: {
            PreferenceView()
        }
    }
}

struct PreferenceButton_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceButton()
            .environmentObject(SimpleNavigation.state())
    }
}
