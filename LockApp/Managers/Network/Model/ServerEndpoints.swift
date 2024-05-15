//
//  ServerEndpoints.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 15.05.2024.
//

import Foundation

enum ServerEndpoint: String {
    case validate = "/validate"
    
    case refreshToken = "/auth/refresh"
}
