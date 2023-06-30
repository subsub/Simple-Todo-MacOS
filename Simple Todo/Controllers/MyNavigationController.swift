//
//  MyNavigationController.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 30/06/23.
//

import SwiftUI

class MyNavigationState: ObservableObject {
    static let instance = MyNavigationState()
    
    @Published var viewMaps: [String: AnyView] = [:]
    @Published var views: [String] = []
    @Published var currentView: String? = nil
    @Published var data: [String: Any] = [:]
    
    func popTo(id: String?) {
        currentView = id
        data.removeAll()
    }
    
    func push(id: String?, data: [String: Any]? = nil) {
        currentView = id
        guard let data = data else {
            return
        }
        self.data = data
    }
}

struct MyNavigationLink: View {
    @EnvironmentObject var navigationState: MyNavigationState
    @State var isHovered: Bool = false
    var content: AnyView
    var destination: AnyView
    let id: String
    var focusColor: Color? = .blue
    
    init(focusColor: Color? = nil,
         @ViewBuilder content: @escaping () -> some View,
         @ViewBuilder destination: @escaping () -> some View) {
        self.content = AnyView(content())
        self.destination = AnyView(destination())
        self.id = UUID().uuidString
        self.focusColor = focusColor ?? .blue
    }
    
    init(id: String,
         focusColor: Color? = nil,
         @ViewBuilder content: @escaping () -> some View, @ViewBuilder destination: @escaping () -> some View) {
        self.id = id
        self.content = AnyView(content())
        self.destination = AnyView(destination())
        self.focusColor = focusColor ?? .blue
    }
    
    var body: some View {
        Button {
            navigationState.currentView = id
        } label: {
            content
        }
        .buttonStyle(.plain)
        .background(
            isHovered ? focusColor : .clear
        )
        .onHover { hovered in
            isHovered = hovered
        }
        .onAppear {
            if !navigationState.views.contains(id) {
                navigationState.views.append(id)
            }
            navigationState.viewMaps[id] = destination
        }
    }
}

struct MyNavigationController<Content: View>: View {
    let navigationState: MyNavigationState = MyNavigationState.instance
    
    @ViewBuilder var content: Content
    
    
    var body: some View {
        MyNavigationView {
            content
        }
        .environmentObject(navigationState)
        
    }
}

struct MyNavigationView: View {
    @EnvironmentObject var navigationState: MyNavigationState
    @State var keyObserver: NSKeyValueObservation?
    var content: AnyView
    
    init(@ViewBuilder content: () -> some View) {
        self.content = AnyView(content())
    }
    
    var body: some View {
        let currentView = navigationState.viewMaps[navigationState.currentView ?? ""]
        VStack {
            if currentView != nil {
                currentView
            } else {
                content
            }
        }
        .onAppear {
            keyObserver = NSApplication.shared.observe(\.keyWindow) { x, y in
                print("Is Visible: \(NSApplication.shared.keyWindow != nil)")
                if (NSApplication.shared.keyWindow == nil) {
                    navigationState.currentView = nil
                }
            }
        }
    }
}

struct MyNavigationController_Previews: PreviewProvider {
    static var previews: some View {
        MyNavigationController {
            Text("Hello there")
        }
    }
}
