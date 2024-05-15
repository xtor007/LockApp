//
//  Keychain.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 15.05.2024.
//

import Foundation
import Security

/// Utility to assess keychain storage in order to save, read and remove data
/// using key-value like API.
public class Keychain: KeychainProtocol {
    
    static let shared: KeychainProtocol = Keychain()

    /// Identified of the keychain access group that might
    /// include multiple applications with shared keychain store.
    private let accessGroup: String?

    private init(accessGroup: String? = nil) {
        self.accessGroup = accessGroup
    }

    /// Creates record in Keychain for key with sepcified value.
    /// - Parameters:
    ///   - data: Any data to be written to Keychain storage..
    ///   - forKey: Key that represents data written to keychain.
    /// - Returns: Boolean value indicating success or failure of operation.
    public func save(_ data: Any?, forKey: String) -> Bool {
        guard let data else {
            return remove(forKey: forKey)
        }
        let savedData: Data
        do {
            if #available(iOS 11.0, macOS 10.13, watchOS 4.0, *) {
                savedData = try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: true)
            } else {
                savedData = NSKeyedArchiver.archivedData(withRootObject: data)
            }
        } catch {
            savedData = Data()
        }

        var query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: forKey,
            kSecValueData as String: savedData] as [String: Any]

        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup as String
        }
        SecItemDelete(query as CFDictionary)

        let status = SecItemAdd(query as CFDictionary, nil)

        if status == noErr {
            return true
        } else {
            return false
        }
    }

    /// Reads any data value for specified key.
    /// - Parameter forKey: Key that represents data written to Keychain.
    /// - Returns: Optional object written by specified key. Might return nil in case key does not exist.
    public func value(forKey: String) -> Any? {
        var query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: forKey,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne] as [String: Any]

        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup as String
        }

        var dataTypeRef: AnyObject?

        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == noErr {
            if let dataRef = dataTypeRef as? Data {
                let data: Any?
                do {
                    if #available(macOS 10.11, *) {
                        data = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(dataRef)
                    } else {
                        data = nil
                    }
                } catch {
                    data = nil
                }
                return data
            }
            return nil
        } else {
            return nil
        }
    }

    /// Removes any data for specified key.
    /// - Parameter forKey: Key that represents data written to Keychain.
    /// - Returns: Boolean value indicating success or failure of operation.
    public func remove(forKey: String) -> Bool {
        var query = [
        kSecClass as String: kSecClassGenericPassword as String,
        kSecAttrAccount as String: forKey] as [String: Any]

        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup as String
        }

        let status: OSStatus = SecItemDelete(query as CFDictionary)

        if status == noErr {
            return true
        } else {
            return false
        }
    }
}

/// Defines protocol for Keychain communication including CRUD operations.
public protocol KeychainProtocol {
    func save(_ data: Any?, forKey: String) -> Bool
    func value(forKey: String) -> Any?
    func remove(forKey: String) -> Bool
}
