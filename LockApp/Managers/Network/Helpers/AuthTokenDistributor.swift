//
//  AuthTokenDistributor.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 16.05.2024.
//

import Foundation

class AuthTokenDistributor {
    func getToken() async throws -> String {
        if let token = KeychainValues.authToken,
            UserDefaults.expirationDate ?? .distantPast < .now {
            return token
        }
        let _: Bool = try await withCheckedThrowingContinuation { continuation in
            TokenRefresher().refreshToken { result in
                switch result {
                case .success(_):
                    continuation.resume(returning: true)
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        }
        if let token = KeychainValues.authToken,
            UserDefaults.expirationDate ?? .distantFuture > .now {
            return token
        }
        throw TokenDistributorError.failedAuth
    }
}

enum TokenDistributorError: Error {
    case failedAuth
}
