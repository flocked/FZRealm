//
//  DBManager.swift
//  PornBase
//
//  Created by Florian Zand on 13.05.23.
//

import AppKit
import RealmSwift


public extension Realm {
    static var RealmObjectRealm: Realm? {
        return nil
    }
}

/**
 A realm database manager.
 
 It's shared instances realm object as default value RealmObject.
 */
public class DBManager {
    /**
     The singleton database manager instance.
     */
    public static let shared = try! DBManager()
    
    /**
     The realm object.
     */
    public fileprivate(set) var realm: Realm
    
    /**
     The url to the realm .sqlite database file.
     */
    public let databaseFile: URL
    
    /**
     A Boolean value that indicates whether a new database should be created each init (e.g. suitable for debugging).
     */
    public let createNewDatabaseAtInit: Bool = true
    
    /**
    Creates an database manager object that uses a realm file at ~/Library/Application Support/{*App Bundle Name*}/Database.sqlite
     
     If non existing, It creates a new realm database.
     
     - Throws Throws if the realm database couldn't be created.
     
     - Returns The database manager object
    */
    public convenience init() throws {
        try self.init(url: .appSupportDatabaseFile)
    }
    
    /**
    Creates an database manager object that uses a realm file at the specifed url.
     
     - Parameters url: The url to the .sqlite realm file.
     - Throws Throws if no realm file at the specifed url exists or the realm database couldn't be created.
     
     - Returns The database manager object
    */
    public init(url: URL) throws {
        if createNewDatabaseAtInit, FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.removeItem(at: url)
        }
        
        var config = Realm.Configuration()
        config.fileURL = url
        self.realm = try Realm(configuration: config)
        self.databaseFile = url
    }
    
    /**
     Deletes all objects from the database.

     - Throws Throws if the objects couldn't be deleted from the database.
    */
    public func deleteAllObjects() throws {
        try self.realm.write {
            self.realm.deleteAll()
        }
    }
    
    /**
    Deletes the curren't realm database and creates a new.
     
     - Throws Throws if the database couldn't be deleted or a new realm database couldn't be created.
    */
    public func deleteDatabase() throws {
        if FileManager.default.fileExists(at: databaseFile) {
           try FileManager.default.removeItem(at: databaseFile)
            var config = Realm.Configuration()
            config.fileURL = databaseFile
            self.realm = try Realm(configuration: config)
        }
        
    }
}
