//
//  RequestMaker.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 15.05.2024.
//

import Foundation

class RequestMaker {
    
    private var request: URLRequest?
    
    func addURL(_ link: String, endpoint: ServerEndpoint? = nil) throws {
        guard let url = URL(string: link + (endpoint?.rawValue ?? "")) else { throw RequestMakerError.failedURL }
        request = URLRequest(url: url)
    }
    
    func makeGet() {
        request?.httpMethod = "GET"
    }
    
    func addAuthorization(token: String) {
        request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
    
    func getRequest() throws -> URLRequest {
        guard let request = request else { throw RequestMakerError.noRequest }
        return request
    }
    
}

enum RequestMakerError: Error {
    case noRequest, failedURL
}
