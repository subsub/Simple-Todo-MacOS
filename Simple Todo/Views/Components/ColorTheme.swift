//
//  ColorTheme.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 20/04/25.
//

import SwiftUI

struct ColorTheme: ColorDelegate {
    static let instance = ColorTheme()
    
    var textDefault: Color {
        get { .init(light: .black, dark: .white) }
    }
    
    var textInactive: Color {
        get { .init(light: .init(hex: "#ffadadad"), dark: .init(hex: "#ff191919")) }
    }
    
    var textButtonDefault: Color {
        get { .init(light: .blue, dark: .blue) }
    }
    
    var textButtonInactive: Color {
        get { .init(light: .init(hex: "#ffadadad"), dark: .init(hex: "#ff191919")) }
    }
    
    var warning: Color {
        get { .init(light: .init(hex: "#ffa82a00"), dark: .init(hex: "#ffff602b"))}
    }
    
    var defaultBackground: Color {
        get { .init(light: .init(hex: "#ffd9d9d9"), dark: .init(hex: "#ff383838")) }
    }
    
    var defaultShadow: Color {
        get { .init(light: .init(hex: "#ff919191"), dark: .init(hex: "#ff262626")) }
    }
    
    var staticWhite: Color {
        get { .white }
    }
}
