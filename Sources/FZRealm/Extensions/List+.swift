//
//  List+.swift
//  
//
//  Created by Florian Zand on 13.05.23.
//

import Foundation
import RealmSwift

extension List: ExpressibleByArrayLiteral {
    /**
     Creates a List with the objects that are contained in a given array.
     
     - Parameter values: An array that holds objects of Element.
     */
    public convenience init<S: Sequence<Element>>(_ values: S) {
        self.init()
        self.append(objectsIn: values)
    }
    
    public convenience init(arrayLiteral elements: Element...) {
        self.init()
        self.append(objectsIn: elements)
    }
        
    public static func += <S>(lhs: inout List, rhs: S) where S: Sequence<Element> {
        lhs.append(objectsIn: rhs)
    }
}
