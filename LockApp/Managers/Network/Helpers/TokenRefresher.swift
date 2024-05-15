//
//  TokenRefresher.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 16.05.2024.
//

import Foundation

class TokenRefresher {
    func refreshToken(onFinish: @escaping (Result<Any?, Error>) -> Void) {
        guard let refreshToken = KeychainValues.refreshToken else {
            onFinish(.failure(RefreshTokerError.refreshTokenAbsent))
            return
        }
        guard let serverLink = UserDefaults.serverLink else {
            onFinish(.failure(RefreshTokerError.noServer))
            return
        }
        
        Task {
            do {
                let request = try makeRequest(serverLink: serverLink, token: refreshToken)
                let tokens = try await sendRequest(request)
                
                UserDefaults.expirationDate = tokens.expDate
                KeychainValues.authToken = tokens.auth
                
                onFinish(.success(nil))
            } catch {
                onFinish(.failure(error))
            }
        }
    }
    
    private func makeRequest(serverLink: String, token: String) throws -> URLRequest {
        let requestMaker = RequestMaker()
        try requestMaker.addURL(serverLink, endpoint: .refreshToken)
        requestMaker.makeGet()
        requestMaker.addAuthorization(token: token)
        return try requestMaker.getRequest()
    }
    
    private func sendRequest(_ request: URLRequest) async throws -> AuthTokens {
        let networkManager = NetworkManager()
        return try await networkManager.makeRequest(request)
    }
}

enum RefreshTokerError: Error {
    case refreshTokenAbsent, noServer
}
