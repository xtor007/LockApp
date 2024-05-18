//
//  Texts.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 15.05.2024.
//

import Foundation

enum Texts {
    
    // MARK: - Global
    enum AlertTexts: String {
        case error = "Error"
        case dangerous = "Dangerous action"
        case areYouSure = "Are you sure?"
    }
    enum ButtonsTexts: String {
        case ok = "OK"
        case connect = "Connect"
        case login = "Login"
        case forgotPassword = "Forgot Password"
        case next = "Next"
        case confirm = "Confirm"
        case prev = "Prev"
        case changePassword = "Change password"
        case logout = "Log out"
        case cancel = "Cancel"
        case delete = "Delete"
    }
    
    // MARK: - Preparation
    enum EnterServer: String {
        case enterServer = "Enter your company server, please"
    }
    enum Loading: String {
        case loadingMessage = "Please, wait a few seconds"
    }
    enum Registration: String {
        case email = "Your email"
        case password = "Your password"
        case passwordHelp = "If you have not changed your password, it is in your email."
        case changeServer = "Change server"
        case code = "Enter code"
        case newPassword = "New password"
        case confirmPassword = "Confirm password"
    }
    
    // MARK: Main
    enum Main: String {
        case info = "Info"
        case hello = "Hello, "
        case logs = "Logs"
        case average = "Average:"
        case open = "OPEN"
    }
    enum Admin: String {
        case admin = "Admin"
        case all = "All"
    }
    enum Settings: String {
        case settings = "Settings"
        case failed = "Failed"
    }
    enum Logs: String {
        case noData = "No data available"
        case logs = "Logs"
    }
}
