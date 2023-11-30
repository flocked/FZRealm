//
//  Persistable+.swift
//  
//
//  Created by Florian Zand on 13.05.23.
//

import AppKit
import RealmSwift
import FZSwiftUtils
import FZUIKit
import AVKit


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

// MARK: CGRect
extension CGRect: CustomPersistable {
    public typealias PersistedType = PersitableArray<Double>
    public init(persistedValue: PersitableArray<Double>) {
        self = persistedValue.cgrect()
    }
    
    public var persistableValue: PersitableArray<Double> {
        return PersitableArray(self)
    }
}

extension PersitableArray {
    public convenience init(_ rect: CGRect) where Element == Double {
        self.init()
        self.array = [rect.x, rect.x, rect.width, rect.height]
     }
    
    func cgrect() -> CGRect  where Element == Double {
        CGRect(x: self[0], y: self[1], width: self[2], height: self[3])
    }
}

// MARK: CGPoint
extension CGPoint: CustomPersistable {
    public typealias PersistedType = PersitableArray<Double>
    public init(persistedValue: PersitableArray<Double>) {
        self = persistedValue.cgpoint()
    }
    
    public var persistableValue: PersitableArray<Double> {
        return PersitableArray(self)
    }
}

extension PersitableArray {
    public convenience init(_ point: CGPoint) where Element == Double {
        self.init()
        self.array = [point.x, point.x]
     }
    
    func cgpoint() -> CGPoint where Element == Double {
        CGPoint(x: self[0], y: self[1])
    }
}

// MARK: CGSize
extension CGSize: CustomPersistable {
    public typealias PersistedType = PersitableArray<Double>
    public init(persistedValue: PersitableArray<Double>) {
        self = persistedValue.cgsize()
    }
    
    public var persistableValue: PersitableArray<Double> {
        PersitableArray(self)
    }
}

extension PersitableArray {
    public convenience init(_ size: CGSize) where Element == Double {
       self.init()
       self.array = [size.width, size.height]
    }
    
    func cgsize() -> CGSize where Element == Double {
        CGSize(width: self[0], height: self[1])
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

// MARK: CMTime
@available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
extension CMTime: CustomPersistable {
    public typealias PersistedType = PersitableArray<Double>
    public init(persistedValue: PersitableArray<Double>) {
        self = persistedValue.cmtime()
    }
    
    public var persistableValue: PersitableArray<Double> {
        PersitableArray(self)
    }
}

@available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
extension PersitableArray {
    public convenience init(_ time: CMTime) where Element == Double {
        self.init()
        self.array = [Double(time.value), Double(time.timescale), Double(time.flags.rawValue), Double(time.epoch)]
     }
    
    func cmtime() -> CMTime where Element == Double {
        CMTime(value: Int64(self[0]), timescale: Int32(self[1]), flags: CMTimeFlags(rawValue: UInt32(self[2])),  epoch: Int64(self[3]))
    }
}

// MARK: DataSize
extension DataSize: CustomPersistable {
    public typealias PersistedType = PersitableArray<Double>

    public init(persistedValue: PersitableArray<Double>) {
        self = persistedValue.datasize()
    }
    
    public var persistableValue: PersitableArray<Double> {
        return PersitableArray(self)
    }
}

extension PersitableArray {
    public convenience init(_ size: DataSize) where Element == Double {
        self.init()
        self.array = [Double(size.bytes), Double(size.countStyle.rawValue)]
     }
    
    func datasize() -> DataSize where Element == Double {
        DataSize(Int(self[0]), countStyle: .init(rawValue: Int(self[1]))!)
    }
}

extension CustomPersistable where Self == NSUIColor {
    public init(persistedValue: PersitableArray<Double>) {
        self.init(red: persistedValue[0], green: persistedValue[1], blue: persistedValue[2], alpha: persistedValue[3])
    }
}

extension NSUIColor: CustomPersistable {
    public typealias PersistedType = PersitableArray<Double>

    
    public var persistableValue: PersitableArray<Double> {
        return PersitableArray(self)
    }
}

// MARK: NSColor/UIColor
extension PersitableArray {
    public convenience init(_ color: NSUIColor) where Element == Double {
        self.init()
        let components = color.rgbaComponents()
        self.array = [Double(components.red), Double(components.green), Double(components.blue), Double(components.alpha)]
     }
}

/*
extension CustomPersistable where Self == CGColor {
    public init(persistedValue: PersitableArray<Double>) {
        self.init(red: persistedValue[0], green: persistedValue[1], blue: persistedValue[2], alpha: persistedValue[3])
    }
}


extension CGColor: CustomPersistable {
    public typealias PersistedType = PersitableArray<Double>

    
    public var persistableValue: PersitableArray<Double> {
        return PersitableArray(self)
    }
}

// MARK: NSColor/UIColor
extension PersitableArray {
    public convenience init(_ color: CGColor) where Element == Double {
        self.init()
        if let components = color.rgbaComponents() {
            self.array = [Double(components.red), Double(components.green), Double(components.blue), Double(components.alpha)]
        } else {
            self.array = [0, 0, 0, 0]
        }
     }
}
*/
