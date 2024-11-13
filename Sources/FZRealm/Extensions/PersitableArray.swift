//
//  PersitableArray.swift
//
//
//  Created by Florian Zand on 14.05.23.
//

import Foundation
import RealmSwift
import FZSwiftUtils

/**
 Array of `@Persisted` objects that can be used for conforming types to `CustomPersistable`.
 
 `PersitableArray` is used as storage for many types (like 'URL', 'CGRect', 'UIColor`, etc.) to conform them to `CustomPersistable` so that they can Realm Object properties.
 
 Example usage to conform a custom type to `CustomPersistable`:
 
 ```swift
 struct Car {
    let speed: Double
    let price: Double
    let size: CGSize
 }
 
 extension Car: CustomPersistable {
    typealias PersistedType = PersitableArray<Double>
 
    init(persistedValue: PersitableArray<Double>) {
         self = Car(speed: persistedValue[0], price: persistedValue[1], size: CGSize(width: persistedValue[2], height: persistedValue[3]))
     }
     
    var persistableValue: PersitableArray<Double> {
         return [speed, price, width, height]
     }
 }
 ```
 */
public final class PersitableArray<Element: RealmCollectionValue & _Persistable>: EmbeddedObject, ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Element...) {
        self.array = List(elements)
    }
    
    public init(_ values: [Element]) {
        self.array = List(values)
    }
        
    @Persisted public var array: List<Element> = []

    public subscript(index: Int) -> Element {
        return array[index]
    }
}


