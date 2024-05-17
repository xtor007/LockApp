//
//  DBValues.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 17.05.2024.
//

import Foundation

@propertyWrapper
struct DBValue<T: Equatable> {
    let key: DBField
    let db: DB
    
    init(key: DBField, db: DB) {
        self.key = key
        self.db = db
    }

    var wrappedValue: [T] {
        get {
            db.getAll(key) as? [T] ?? []
        }
        set {
            ()
        }
    }
    
    mutating func add(_ value: T) {
        db.addElement(for: key, value)
        db.save()
    }
    
    mutating func delete(at id: UUID) {
        db.removeElement(id, on: key)
        db.save()
    }
}

class DBValues {
    @DBValue<EnterDBModel>(key: .enters, db: CoreDataManager.shared)
    static var enters: [EnterDBModel]
    static func addEnters(_ values: [EnterDBModel]) { values.forEach({ _enters.add($0) }) }
    static func deleteEnter(at id: UUID) { _enters.delete(at: id) }
}
