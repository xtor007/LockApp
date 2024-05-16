//
//  UserDefaultsValues.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 15.05.2024.
//

import Foundation

@propertyWrapper
struct UserDefaultsValue<T: Equatable> {
    let storageKey: String
    let storageID: String?
    let notificationKey: NSNotification.Name?
    
    init(storageKey: String, notificationKey: NSNotification.Name? = nil, storageID: String? = nil) {
        self.storageKey = storageKey
        self.notificationKey = notificationKey
        self.storageID = storageID
    }

    var wrappedValue: T? {
        get {
            if let storageID {
                return UserDefaults(suiteName: storageID)!.value(forKey: storageKey) as? T
            } else {
                return UserDefaults.standard.value(forKey: storageKey) as? T
            }
        }
        set {
            let storage = storageID == nil ? UserDefaults.standard : UserDefaults(suiteName: storageID)!
            let oldValue = storage.value(forKey: storageKey) as? T
            storage.set(newValue, forKey: storageKey)
            if let notificationKey, oldValue != newValue {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: notificationKey, object: nil)
                }
            }
        }
    }
}

extension UserDefaults {
    @UserDefaultsValue<String>(storageKey: "serverLink", notificationKey: .serverLinkChanged)
    static var serverLink: String?
    
    @UserDefaultsValue<Date>(storageKey: "expirationDate")
    static var expirationDate: Date?
    
    @UserDefaultsValue<Double>(storageKey: "averageTime")
    static var averageTime: Double?
}
