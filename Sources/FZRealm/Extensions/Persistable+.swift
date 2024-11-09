//
//  Persistable+.swift
//
//
//  Created by Florian Zand on 13.05.23.
//

import Foundation
import RealmSwift
import FZSwiftUtils
import FZUIKit
#if os(macOS)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif



// MARK: URL
extension URL: CustomPersistable {
    public typealias PersistedType = String
    
    public init(persistedValue: String) {
        self.init(fileURLWithPath: persistedValue)
    }
    
    public var persistableValue: String {
        self.path
    }
}

// MARK: CGPoint
extension CGPoint: CustomPersistable {
    public typealias PersistedType = PersitableArray<Double>
    
    public init(persistedValue: PersitableArray<Double>) {
        self = CGPoint(x: persistedValue[0], y: persistedValue[1])
    }
    
    public var persistableValue: PersitableArray<Double> {
        PersitableArray([x, y])
    }
}

// MARK: CGSize
extension CGSize: CustomPersistable {
    public typealias PersistedType = PersitableArray<Double>
    public init(persistedValue: PersitableArray<Double>) {
        self = CGSize(width: persistedValue[0], height: persistedValue[1])
    }
    
    public var persistableValue: PersitableArray<Double> {
        PersitableArray([width, height])
    }
}

// MARK: CGRect
extension CGRect: CustomPersistable {
    public typealias PersistedType = PersitableArray<Double>
    public init(persistedValue: PersitableArray<Double>) {
        self = CGRect(x: persistedValue[0], y: persistedValue[1], width: persistedValue[2], height: persistedValue[3])
    }
    
    public var persistableValue: PersitableArray<Double> {
        return PersitableArray([x, y, width, height])
    }
}

// MARK: TimeDuration
extension TimeDuration: CustomPersistable {
    public typealias PersistedType = Double

    public init(persistedValue: Double) {
        self.init(persistedValue)
    }
    
    public var persistableValue: Double {
        return self.seconds
    }
}

// MARK: DataSize
extension DataSize: CustomPersistable {
    public typealias PersistedType = PersitableArray<Int>

    public init(persistedValue: PersitableArray<Int>) {
        self = .init(persistedValue[0], countStyle: .init(rawValue: persistedValue[1])!)
    }
    
    public var persistableValue: PersitableArray<Int> {
        PersitableArray([self.bytes, countStyle.rawValue])
    }
}

// MARK: CGColor
extension CGColor: CustomPersistable {
    public typealias PersistedType = PersitableArray<Double>
    
    public var persistableValue: PersitableArray<Double> {
        guard let components = rgbaComponents() else { return [0, 0, 0, 0] }
        return [components.red, components.green, components.blue, components.alpha]
    }
}

extension CustomPersistable where Self == CGColor {
    public init(persistedValue: PersitableArray<Double>) {
        self.init(red: persistedValue[0], green: persistedValue[1], blue: persistedValue[2], alpha: persistedValue[3])
    }
}

#if os(macOS) || canImport(UIKit)
// MARK: NSColor/UIColor
extension NSUIColor: CustomPersistable {
    public typealias PersistedType = PersitableArray<Double>

    
    public var persistableValue: PersitableArray<Double> {
        let components = rgbaComponents()
        return [components.red, components.green, components.blue, components.alpha]
    }
}

extension CustomPersistable where Self == NSUIColor {
    public init(persistedValue: PersitableArray<Double>) {
        self.init(red: persistedValue[0], green: persistedValue[1], blue: persistedValue[2], alpha: persistedValue[3])
    }
}
#endif
