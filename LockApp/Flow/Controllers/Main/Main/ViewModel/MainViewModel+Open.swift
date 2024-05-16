//
//  MainViewModel+Open.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 16.05.2024.
//

import Foundation

extension MainViewModel {
    func openByServer() async throws -> Bool {
        let token = try await AuthTokenDistributor().getToken()
        let request = try makeOpenRequest(token: token)
        let result: OpeningResult = try await NetworkManager().makeRequest(request)
        return result.isSuccess
    }
    
    private func makeOpenRequest(token: String) throws -> URLRequest {
        let maker = RequestMaker()
        try maker.addURL(UserDefaults.serverLink, endpoint: .open)
        maker.addAuthorization(token: token)
        maker.makeGet()
        return try maker.getRequest()
    }
}
