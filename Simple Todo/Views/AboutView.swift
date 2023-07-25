//
//  AboutView.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 15/07/23.
//

import SwiftUI
import simple_navigation

struct AboutView: View {
    @EnvironmentObject var navigationState: SimpleNavigationState
    
    var body: some View {
        VStack {
            SimpleNavigation.bar(title: "About") {
                navigationState.popTo(id: "preference")
            }
            
            VStack {
                if let image = NSImage(named: "AppIcon") {
                    Image(nsImage: image)
                        .frame(width: 60, height: 60)
                        .scaleEffect(0.5)
                }
                if let appName = Bundle.main.appName {
                    Text(appName)
                        .font(.system(.title2))
                }
                HStack {
                    Text("Version:")
                    if let appVersion = Bundle.main.releaseVersion, let buildVersion = Bundle.main.buildVersion {
                        Text("\(appVersion)(\(buildVersion))")
                    }
                }
            }.padding(defaultPadding)
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
            .environmentObject(SimpleNavigation.state())
    }
}
