//
//  SettingsViewModel.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 17.05.2024.
//

import Foundation

class SettingsViewModel: ObservableObject {
    
    @Published var name: String
    @Published var surname: String
    @Published var email: String
    @Published var department: String
    
    @Published var theme = ThemeManager.shared.currentTheme {
        didSet {
            ThemeManager.shared.currentTheme = theme
        }
    }
    
    @Published var alert: AlertItem?
    
    weak var showerDelegate: SettingsShowerDelegate?
    
    init(user: EmployerModel) {
        name = user.name ?? ""
        surname = user.surname ?? ""
        email = user.email ?? ""
        department = user.department ?? ""
    }
    
    func logout() {
        alert = AlertContext.dangerousActionAlert { [weak self] in
            guard let self else { return }
            clearStorages()
            showerDelegate?.showRegistration()
        }
    }
    
    func changePassword() {
        showerDelegate?.openChangePasswordFromSettings()
    }
    
    private func clearStorages() {
        KeychainValues.authToken = nil
        KeychainValues.refreshToken = nil
        
        UserDefaults.userInfo = nil
        UserDefaults.expirationDate = nil
        UserDefaults.averageTime = nil
        
        let enters = DBValues.enters
        enters.forEach({ DBValues.deleteEnter(at: $0.id) })
        
        //TODO: Employers
    }
    
}
