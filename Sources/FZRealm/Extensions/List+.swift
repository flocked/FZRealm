//
//  List+.swift
//  PornBase
//
//  Created by Florian Zand on 13.05.23.
//

import Foundation
import RealmSwift

extension List: ExpressibleByArrayLiteral {
    /**
     Creates a List with the objects that are contained in a given array.
     
     - Parameters values: An array that holds objects of Element.
     */
    public convenience init<S: Sequence<Element>>(_ values: S) {
        self.init()
        self.append(objectsIn: values)
    }
    
    public convenience init(arrayLiteral elements: Element...) {
        self.init()
        self.append(objectsIn: elements)
    }
    
    public typealias ArrayLiteralElement = List.Element
}
