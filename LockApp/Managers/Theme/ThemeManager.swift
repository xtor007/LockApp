//
//  ThemeManager.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 24.05.2024.
//

import UIKit

class ThemeManager {
    
    static let shared = ThemeManager()
    
    var currentTheme = Theme(rawValue: UserDefaults.theme ?? 2) ?? .system {
        didSet {
            UserDefaults.theme = currentTheme.rawValue
            applyTheme()
        }
    }
    
    private init() {}
    
    func applyTheme() {
        guard let window = UIApplication.shared.windows.first else {
            return
        }
        window.overrideUserInterfaceStyle = currentTheme.userInterfaceStyle
    }
    
}
