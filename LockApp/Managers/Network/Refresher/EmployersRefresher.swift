//
//  EmployersRefresher.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 17.05.2024.
//

import Foundation

class EmployersRefresher {
    func refreshData(onFinish: @escaping (Result<Any?, Error>) -> Void) {
        Task {
            do {
                let token = try await AuthTokenDistributor().getToken()
                let request = try makeRequest(serverLink: UserDefaults.serverLink, token: token)
                let model = try await sendRequest(request)
                
                DBValues.addEmployers(model.employers.map { employer in
                    .init(
                        employer: employer.employer,
                        average: employer.statistic.averageTime
                    )
                })
                
                onFinish(.success(nil))
            } catch {
                onFinish(.failure(error))
            }
        }
    }
    
    private func makeRequest(serverLink: String?, token: String) throws -> URLRequest {
        let requestMaker = RequestMaker()
        try requestMaker.addURL(serverLink, endpoint: .all)
        requestMaker.makeGet()
        requestMaker.addAuthorization(token: token)
        return try requestMaker.getRequest()
    }
    
    private func sendRequest(_ request: URLRequest) async throws -> Employers {
        let networkManager = NetworkManager()
        return try await networkManager.makeRequest(request)
    }
}
