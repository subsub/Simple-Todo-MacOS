//
//  PreferenceButton.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 01/07/23.
//

import SwiftUI

struct PreferenceButton: View {
    var body: some View {
        MyNavigationLink(id: "preference", colorDelegate: ColorTheme.instance) {
            Text("Preference")
        } destination: {
            PreferenceView()
        }
    }
}

struct PreferenceButton_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceButton()
            .environmentObject(MyNavigationState())
    }
}
