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
    @Binding var isShowing: Bool
    var title: String
    var type: ToastType
    
    var body: some View {
        VStack {
            if isShowing {
                Text(title)
                    .padding(defaultPadding)
                    .background(type.backgroundColor())
                    .cornerRadius(4)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                isShowing = false
                            }
                        }
                    }
            }
        }
        .transition(.move(edge: .top))
        .cornerRadius(8)
        .frame(maxHeight: .infinity, alignment: .topLeading)
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
        MyToast(isShowing: .constant(true), title: "Something", type: .Success)
    }
}
