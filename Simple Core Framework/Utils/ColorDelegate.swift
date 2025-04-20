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
    var defaultBackground: Color { get }
    var defaultShadow: Color { get }
    var staticWhite: Color { get }
}
