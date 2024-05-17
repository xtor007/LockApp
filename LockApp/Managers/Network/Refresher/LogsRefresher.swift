//
//  LogsRefresher.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 17.05.2024.
//

import Foundation

class LogsRefresher {
    let id: UUID
    let fromDate: Date?
    
    init(id: UUID, fromDate: Date?) {
        self.id = id
        self.fromDate = fromDate
    }
    
    func refreshData(onFinish: @escaping (Result<Any?, Error>) -> Void) {
        Task {
            do {
                let token = try await AuthTokenDistributor().getToken()
                let request = try makeRequest(serverLink: UserDefaults.serverLink, token: token)
                let model = try await sendRequest(request)
                
                DBValues.addEnters(model.logs.map({ enter in
                    EnterDBModel(
                        id: UUID(),
                        employerId: id,
                        time: enter.time,
                        isOn: enter.isOn
                    )
                }))
                
                onFinish(.success(nil))
            } catch {
                onFinish(.failure(error))
            }
        }
    }
    
    private func makeRequest(serverLink: String?, token: String) throws -> URLRequest {
        let requestMaker = RequestMaker()
        try requestMaker.addURL(serverLink, endpoint: .logs)
        try requestMaker.makePost(GetLogsRequest(valid: true, id: id, afterDate: fromDate))
        requestMaker.addAuthorization(token: token)
        return try requestMaker.getRequest()
    }
    
    private func sendRequest(_ request: URLRequest) async throws -> Logs {
        let networkManager = NetworkManager()
        return try await networkManager.makeRequest(request)
    }
}
