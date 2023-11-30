//
//  PersitableArray.swift
//  
//
//  Created by Florian Zand on 14.05.23.
//

import Foundation
import RealmSwift
import AVKit
import FZSwiftUtils

/** Array of @Persisted objects that can be used for creating CustomPersistable's.
 
 PersitableArray is used as storage for many types (like URL, CGRect, CGPoint, CGSize, TimeDuration, CMTime & DataSize) to conform them to CustomPersistable so that they can Realm Object properties.
 */
public class PersitableArray<Element: RealmCollectionValue & _Persistable>: EmbeddedObject, ExpressibleByArrayLiteral {
    public required init(arrayLiteral elements: Element...) {
        self.array = List(elements)
    }
        
    @Persisted public var array: List<Element> = []
    
    public convenience init(_ values: [Element]) {
        self.init()
        self.array = List(values)
    }

    public subscript(index: Int) -> Element {
        return array[index]
    }
}
