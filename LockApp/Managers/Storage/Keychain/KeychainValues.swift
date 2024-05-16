//
//  KeychainValues.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 15.05.2024.
//

import Foundation

@propertyWrapper
struct KeychainValue<T: Equatable> {
    let key: String
    let notificationKey: NSNotification.Name?
    
    init(key: String, notificationKey: NSNotification.Name? = nil) {
        self.key = key
        self.notificationKey = notificationKey
    }

    var wrappedValue: T? {
        get {
            Keychain.shared.value(forKey: key) as? T
        }
        set {
            let oldValue = Keychain.shared.value(forKey: key) as? T
            let _ = Keychain.shared.save(newValue, forKey: key)
            if let notificationKey, oldValue != newValue {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: notificationKey, object: nil)
                }
            }
        }
    }
}

enum KeychainValues {
    @KeychainValue<String>(key: "refreshToken")
    static var refreshToken: String?
    
    @KeychainValue<String>(key: "authToken")
    static var authToken: String?
}
