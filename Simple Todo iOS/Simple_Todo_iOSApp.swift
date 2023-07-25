//
//  Simple_Todo_iOSApp.swift
//  Simple Todo iOS
//
//  Created by Subkhan Sarif on 23/07/23.
//

import SwiftUI
import simple_navigation

@main
struct Simple_Todo_iOSApp: App {
    var body: some Scene {
        WindowGroup {
            SimpleNavigation.controller {
                SimpleNavigation.link(id: "home") {
                    Text("Home")
                } destination: {
                    SimpleNavigation.bar(title:"Home") {
                        
                    }
                    Text("Home page")
                }
                SimpleNavigation.link(id: "page") {
                    Text("page")
                } destination: {
                    
                        SimpleNavigation.bar(title:"Page") {
                            
                        }
                    Text("Page page")
                }
            }
        }
    }
}
