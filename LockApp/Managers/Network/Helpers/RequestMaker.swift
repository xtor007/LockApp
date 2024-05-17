//
//  RequestMaker.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 15.05.2024.
//

import Foundation

class RequestMaker {
    
    private var request: URLRequest?
    
    func addURL(_ link: String?, endpoint: ServerEndpoint? = nil) throws {
        guard let link else { throw RequestMakerError.noServer }
        guard let url = URL(string: link + (endpoint?.rawValue ?? "")) else { throw RequestMakerError.failedURL }
        request = URLRequest(url: url)
    }
    
    func makeGet() {
        request?.httpMethod = "GET"
    }
    
    func makePost(_ dataObject: Encodable) throws {
        request?.httpMethod = "POST"
        request?.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(dataObject)
        request?.httpBody = data
    }
    
    func addAuthorization(token: String) {
        request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
    
    func addAuthorization(login: String, password: String) throws {
        let loginString = "\(login):\(password)"
        guard let loginData = loginString.data(using: .utf8) else {
            throw RequestMakerError.failedAuthWithLogin
        }
        let base64LoginString = loginData.base64EncodedString()
        request?.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
    }
    
    func getRequest() throws -> URLRequest {
        guard let request = request else { throw RequestMakerError.noRequest }
        return request
    }
    
}

enum RequestMakerError: Error {
    case noRequest, failedURL, failedAuthWithLogin, noServer
}
