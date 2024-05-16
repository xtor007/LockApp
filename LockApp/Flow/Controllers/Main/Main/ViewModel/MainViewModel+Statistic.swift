//
//  MainViewModel+Statistic.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 16.05.2024.
//

import Foundation

extension MainViewModel {
    
    func updateStatistic() async throws {
        let authToken = try await AuthTokenDistributor().getToken()
        let request = try makeStatisticRequest(token: authToken)
        let statistic: Statistic = try await NetworkManager().makeRequest(request)
        updateStatisticOnStorage(statistic)
    }
    
    private func makeStatisticRequest(token: String) throws -> URLRequest {
        let maker = RequestMaker()
        try maker.addURL(UserDefaults.serverLink, endpoint: .statistic)
        maker.makeGet()
        maker.addAuthorization(token: token)
        return try maker.getRequest()
    }
    
    private func updateStatisticOnStorage(_ statistic: Statistic) {
        UserDefaults.averageTime = statistic.averageTime
    }
    
}
