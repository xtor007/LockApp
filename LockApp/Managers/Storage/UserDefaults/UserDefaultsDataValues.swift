//
//  UserDefaultsDataValues.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 16.05.2024.
//

import Foundation

@propertyWrapper
struct UserDefaultsDataValue<T: Codable & Equatable> {
    let storageKey: String
    let storageID: String?
    
    init(storageKey: String, storageID: String? = nil) {
        self.storageKey = storageKey
        self.storageID = storageID
    }

    var wrappedValue: T? {
        get {
            let storage = storageID == nil ? UserDefaults.standard : UserDefaults(suiteName: storageID)!
            guard let data = storage.value(forKey: storageKey) as? Data else { return nil }
            return try? JSONDecoder().decode(T.self, from: data)
        }
        set {
            let storage = storageID == nil ? UserDefaults.standard : UserDefaults(suiteName: storageID)!
            let data = try? JSONEncoder().encode(newValue)
            storage.set(data, forKey: storageKey)
        }
    }
}

extension UserDefaults {
    @UserDefaultsDataValue<EmployerModel>(storageKey: "userInfo")
    static var userInfo: EmployerModel?
}
