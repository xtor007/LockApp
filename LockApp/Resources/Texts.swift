//
//  Texts.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 15.05.2024.
//

import Foundation

enum Texts {
    
    // MARK: - Global
    enum ErrorsTexts: String {
        case error = "Error"
    }
    enum ButtonsTexts: String {
        case ok = "OK"
        case connect = "Connect"
    }
    
    // MARK: - Preparation
    enum EnterServer: String {
        case enterServer = "Enter your company server, please"
    }
    enum Loading: String {
        case loadingMessage = "Please, wait a few seconds"
    }
}
