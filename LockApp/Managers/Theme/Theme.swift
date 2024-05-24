//
//  Theme.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 24.05.2024.
//

import UIKit

enum Theme: Int, SelectorItem, CaseIterable, Codable {
    case light, dark, system
    
    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return .unspecified
        }
    }
    
    var name: String {
        switch self {
        case .light:
            Texts.Settings.lightTheme.rawValue
        case .dark:
            Texts.Settings.darkTheme.rawValue
        case .system:
            Texts.Settings.system.rawValue
        }
    }
}
