//
//  Simple_TodoApp.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 29/06/23.
//

import SwiftUI

@main
struct Simple_TodoApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: Simple_TodoDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
