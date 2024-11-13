//
//  RealmObject.swift
//  
//
//  Created by Florian Zand on 14.05.23.
//

import Foundation
import RealmSwift

/// A protocol that provides additional functionality to conforming realm objects  (like saving, editing or deleting an object or fetching all).
public protocol RealmObject: Object {
    /**
     The realm instance to be used for handling the object (like fetching all objects, saving, editing or deleting an object)
     
     It provides ``RealmManager/shared/realm`` as default.
     */
    static var realm: Realm { get }
}

public extension RealmObject {
    static var realm: Realm {
        return RealmManager.shared.realm
    }
}

public extension RealmObject {
    /**
     Returns all objects of the given type stored in the database.

     - Throws: Throws if the objects couldn't be fetched.
     */
    static func all() throws -> Results<Self> {
        return self.realm.objects(Self.self)
    }
    
    /**
     Returns all objects matching the given query in the database.
     
     - Parameter isIncluded: The query closure to use to filter the objects.
     - Throws: Throws if the objects couldn't be fetched.
     */
    static func all(where isIncluded: ((Query<Self>) -> Query<Bool>)) throws -> Results<Self> {
        return try all().where(isIncluded)
    }
    
    /**
     Adds the object to the database.
     
     - Throws: Throws if the object couldn't be added.
     */
    func add() throws {
        try Self.realm.write {
            Self.realm.add(self)
        }
    }
    
    /**
     Deletes the object from the database.
     
     - Throws: Throws if the object couldn't be deleted.
     */
    func delete() throws {
        try Self.realm.write {
            Self.realm.delete(self)
        }
    }
    
    /**
     Saves changes to the object to the database.
     
     - Note: The object needs to have a primary key.
     - Throws: Throws if the object has no primary key or the changes to object couldn't be saved.
     */
    func update() throws {
        guard Self.primaryKey() != nil else { throw RealmError.noPrimaryKey }
            try Self.realm.write {
                Self.realm.add(self, update: .modified)
        }
    }
    
    /**
     Saves changes to the object to the database.
     - Note: The object needs to have a primary key.
     - Parameter onComplete: The block that gets called when the changes have been saved.
     - Throws: Throws if the object has no primary key or the changes to object couldn't be saved.
     */
    func updateAsync(onComplete: ((Error?)->())? = nil) throws {
        guard Self.primaryKey() != nil else { throw RealmError.noPrimaryKey }
        Self.realm.writeAsync({
            Self.realm.add(self, update: .modified)
            }, onComplete: onComplete)
    }
    
    /**
     Edits the object and saves the changes to the database.
     - Parameter block: The block containing the edits to the object.
     - Throws: Throws if the object couldn't be edit.
     */
    func edit<Result>(_ block: ((Self) throws -> Result)) throws {
        try Self.realm.write {
           try block(self)
        }
    }
    
    /**
     Edits the object and saves the changes asynchronously to the database.
     - Parameter block: The block containing the edits to the object.
     - Parameter onComplete: The block that gets called when the saves have been saved.
     - Throws: Throws if the object couldn't be edit.
     */
    func editAsync(_ block: @escaping ((Self) -> ()), onComplete: ((Error?)->())? = nil) throws {
        guard Self.primaryKey() != nil else { throw RealmError.noPrimaryKey }
        Self.realm.writeAsync({
            block(self)
        }, onComplete: onComplete)
    }
    
    /**
     Deletes the objects from the database.
     - Throws: Throws if the objects couldn't be deleted.
     */
    static func deleteAll() throws {
        let allObjects = try all()
        try Self.realm.write {
            Self.realm.delete(allObjects)
        }
    }
    
    /// Observes the object for changes in the database.
    static func observe(_ observation: @escaping (RealmCollectionChange<Results<Self>>)->()) throws -> NotificationToken {
        try all().observe(observation)
    }
}

public extension Sequence where Element: RealmObject {
    /**
     Adds the objects to the database.
     
     - Throws: Throws if the objects couldn't be added.
     */
    func add() throws {
        try Element.realm.write {
            Element.realm.add(self)
        }
    }
    
    /**
     Deletes the objects from the database.
     
     - Throws: Throws if the objects couldn't be deleted.
     */
    func delete() throws {
        try Element.realm.write {
            Element.realm.delete(self)
        }
    }
    
    /**
     Saves changes to the objects in the database.
     
     - Throws: Throws if the object has no primary key or the changes to objects couldn't be saved.
     - Note: The object needs to have a primary key.
     */
    func update() throws {
        guard Element.primaryKey() != nil else { throw RealmError.noPrimaryKey }
        try Element.realm.write {
            Element.realm.add(self, update: .modified)
        }
    }
    
    /**
     Saves changes to the objects in the database asynchronously.
     
     - Parameter onComplete: The block that gets called when the changes have been saved.
     
     - Throws: Throws if the object has no primary key or the changes to objects couldn't be saved.
     - Note: The object needs to have a primary key.
     */
    func updateAsync(onComplete: ((Error?)->())? = nil) throws {
        guard Element.primaryKey() != nil else { throw RealmError.noPrimaryKey }
        Element.realm.writeAsync({
            Element.realm.add(self, update: .modified)
        }, onComplete: onComplete)
    }
}
