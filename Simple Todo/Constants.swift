//
//  Constants.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 03/07/23.
//

import Foundation
import SwiftUI

let toastDurationMs = 300_000_000

protocol ColorDelegate {
    var textDefault: Color { get }
    var textInactive: Color { get }
    var textButtonDefault: Color { get }
    var textButtonInactive: Color { get }
    var warning: Color { get }
}

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
}
