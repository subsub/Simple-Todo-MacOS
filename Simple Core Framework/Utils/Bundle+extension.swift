//
//  Bundle+extension.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 15/07/23.
//

import SwiftUI

extension Bundle {
    
    var releaseVersion: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildVersion: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    
    var appName: String? {
        return infoDictionary?["CFBundleName"] as? String
    }
}
