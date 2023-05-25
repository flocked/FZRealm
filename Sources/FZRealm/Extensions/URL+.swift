//
//  File.swift
//  
//
//  Created by Florian Zand on 25.05.23.
//

import Foundation

internal extension URL {
    static var appSupportDirectory: URL {
        if #available(iOS 16, macOS 13, tvOS 16, watchOS 9, *) {
            return .applicationSupportDirectory
        } else {
            let appSupportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
            return appSupportURL.appendingPathComponent(Bundle.main.bundleName)
        }
    }
    
    static var appSupportDatabaseFile: URL {
        appSupportDirectory.appendingPathComponent("Database.sqlite")
    }
}
