//
//  RealmManager.swift
//  
//
//  Created by Florian Zand on 13.05.23.
//

import RealmSwift
import FZSwiftUtils
import Foundation

/**
 A realm database manager.
 
 It's shared instances realm object as default value RealmObject.
 */
public class RealmManager {
    
    /// The singleton database manager instance.
    public static let shared: RealmManager = try! RealmManager()
    
    /// The realm object.
    public fileprivate(set) var realm: Realm
    var queue: DispatchQueue? = nil
    
    /// The url to the realm .sqlite database file.
    public var databaseFile: URL? {
        realm.configuration.fileURL
    }
    
    /**
     Creates a database manager with the realm database located at the application support folder.
     
     The realm database file is loaded loaded from `~/Library/Application Support/{*App Bundle Name*}/Database.sqlite`.
     
     If no file exists, a new realm database is created.
     
     - Throws: Throws if the realm database couldn't be loaded or created.
          */
    public init() throws {
        if let url = Self.appSupportDatabaseFile {
            realm = try Realm(fileURL: url)
        } else {
            realm = try Realm()
        }
    }
    
    /**
    Creates an database manager object that uses a realm file at the specifed url.
     
     - Parameter url: The url to the .sqlite realm file.
     - Throws: Throws if no realm file at the specifed url exists or the realm database couldn't be created.
    */
    public init(url: URL) throws {
        realm = try Realm(fileURL: url)
    }
    
    /**
    Creates a realm database manager with the specified configuration
     
     - Parameters:
        - configuration: The configuration for the realm databasse.
        - queue: An optional dispatch queue to confine the Realm to. If given, this Realm instance can be used from within blocks dispatched to the given queue rather than on the current thread.

     - Throws: Throws if the database couldn't be loaded or created.
    */
    public init(configuration: Realm.Configuration, queue: DispatchQueue? = nil) throws {
        realm = try Realm(configuration: configuration, queue: queue)
        self.queue = queue
    }
    
    static var appSupportDatabaseFile: URL? {
        return FileManager.default.applicationSupportDirectory(createIfNeeded: true)?.appendingPathComponent("Database").appendingPathExtension("sqlite")
    }
    
    /**
     Deletes all objects from the database.

     - Throws: Throws if the objects couldn't be deleted from the database.
    */
    public func deleteAllObjects() throws {
        try self.realm.write {
            self.realm.deleteAll()
        }
    }
    
    /**
    Deletes the curren't realm database and creates a new.
     
     - Throws: Throws if the database couldn't be deleted or a new realm database couldn't be created.
    */
    public func deleteDatabase() throws {
        if let databaseFile = databaseFile {
            if FileManager.default.fileExists(at: databaseFile) {
                try FileManager.default.removeItem(at: databaseFile)
            }
            self.realm = try Realm(fileURL: databaseFile)
        } else {
            self.realm = try Realm(configuration: realm.configuration, queue: queue)
        }
    }
}

extension RealmManager {
    /**
     Gets all objects of the specified type in the database.
     
     - Parameter type: The type of the object to fetch.
     
     - Throws: Throws if the objects couldn't be fetched.
     */
    func get<T: Object>(_ type: T.Type) throws -> Results<T> {
        realm.objects(type)
    }
    
    /**
     Gets all objects of the specified type matching the predicate in the database.
     
     - Parameters:
        - type: The type of the object to fetch.
        - isIncluded: The query closure to use to filter the objects.
     
     - Throws: Throws if the objects couldn't be fetched.
     */
    func get<T: Object>(_ type: T.Type, where isIncluded: ((Query<T>) -> Query<Bool>)) throws -> Results<T> {
        realm.objects(type).where(isIncluded)
    }
    
    /**
     Adds the object to the database.
     
     - Parameter objects: The object to add.
     
     - Throws: Throws if the object couldn't be saved.
     */
    func add<T: Object>(_ object: T) throws {
        try realm.write {
            realm.add(object)
        }
    }
    
    /**
     Adds the objects to the database.
     
     - Parameter objects: The objects to add.
     
     - Throws: Throws if the objects couldn't be saved.
     */
    func add<S: Sequence>(_ objects: S) throws where S.Iterator.Element: Object {
        try realm.write {
            realm.add(objects)
        }
    }
    
    /**
     Deletes the object from the database.
     
     - Parameter object: The object to update.
     
     - Throws: Throws if the object couldn't be deleted.
     */
    func delete<T: Object>(_ object: T) throws {
        try realm.write {
            realm.delete(object)
        }
    }
    
    /**
     Deletes the objects from the database.
     
     - Parameter objects: The objects to delete.
     
     - Throws: Throws if the objects couldn't be deleted.
     */
    func delete<S: Sequence>(_ objects: S) throws where S.Iterator.Element: Object {
        try realm.write {
            realm.delete(objects)
        }
    }
    
    /**
     Saves changes to the object to the database.
     
     - Parameter object: The object to update.
     
     - Note: The object needs to have a primary key.
     - Throws: Throws if the object has no primary key or the changes to object couldn't be saved.
     */
    func update<T: Object>(_ object: T) throws {
        try realm.write {
            realm.add(object, update: .modified)
        }
    }
    
    /**
     Saves changes of the objects to the database.
     
     - Parameter objects: The objects to update.
     
     - Note: The object needs to have a primary key.
     - Throws: Throws if the object has no primary key or the changes to the objects couldn't be saved.
     */
    func update<S: Sequence>(_ objects: S) throws where S.Iterator.Element: Object {
        try realm.write {
            realm.add(objects, update: .modified)
        }
    }
    
    /**
     Saves changes to the object to the database asynchronously.
     
     - Parameters:
        - object: The object to update.
        - onComplete: The block that gets called when the changes have been saved.
     
     - Throws: Throws if the object has no primary key or the changes to object couldn't be saved.
     - Note: The object needs to have a primary key.
     */
    func updateAsync<T: Object>(_ object: T, onComplete: ((Error?)->())? = nil) {
        realm.writeAsync({
            self.realm.add(object, update: .modified)
        }, onComplete: onComplete)
    }
    
    /**
     Saves changes to the objects to the database asynchronously.
     
     - Parameters:
        - objects: The objects to update.
        - onComplete: The block that gets called when the changes have been saved.
     
     - Throws: Throws if the object has no primary key or the changes to objects couldn't be saved.
     - Note: The object needs to have a primary key.
     */
    func updateAsync<S: Sequence>(_ objects: S, onComplete: ((Error?)->())? = nil) where S.Iterator.Element: Object {
        realm.writeAsync({
            self.realm.add(objects, update: .modified)
        }, onComplete: onComplete)
    }
}

public enum RealmError: Error, CustomStringConvertible {
    /// The realm object has no primary key.
    case noPrimaryKey
    public var description: String {
        switch self {
            case .noPrimaryKey: return "Error: Realm Object has no primary key."
        }
    }
}
