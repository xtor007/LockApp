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
    case getToken = "/auth/getToken"
    case sendEmail = "/auth/changePasswordEmail"
    case changePassword = "/auth/changePassword"
    
    case info = "/info/"
    case statistic = "/info/statistic"
    case all = "/info/all"
    case logs = "/info/logs"
    
    case open = "/open/open"
    case delete = "/command/delete"
    case add = "/command/add"
}
