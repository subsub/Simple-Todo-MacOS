//
//  MyToast.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 03/07/23.
//

import SwiftUI

enum ToastType {
    case Success
    case Warning
    case Error
    
    func backgroundColor() -> Color {
        switch self {
        case .Success: return Color.init(hex: "#00a9c7")
        case .Warning: return .orange
        case .Error: return .red
        }
    }
}

struct MyToast: View {
    @State var isShowing: Bool
    var title: String
    var type: ToastType
    
    var body: some View {
        HStack {
            if isShowing {
                Text(title)
                    .padding(defaultPadding)
                    .background(type.backgroundColor())
                    .transition(.move(edge: .top))
                    .onAppear {
                        delay()
                    }
            }
        }
        .cornerRadius(8)
    }
    
    func delay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation {
                isShowing = false
            }
        }
    }
}

struct MyToast_Previews: PreviewProvider {
    static var previews: some View {
        MyToast(isShowing: true, title: "Something", type: .Success)
    }
}
