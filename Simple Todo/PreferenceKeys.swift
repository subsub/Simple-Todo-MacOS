//
//  PreferenceKeys.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 03/07/23.
//

import SwiftUI

public struct ViewSideLengthKey: PreferenceKey {
    public typealias Value = CGFloat
    public static var defaultValue: CGFloat = .zero
    public static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}
