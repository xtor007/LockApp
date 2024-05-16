//
//  TabBarMaker.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 16.05.2024.
//

import UIKit

class TabBarMaker {
    
    private(set) var mainController: UIViewController?
    private(set) var adminController: UIViewController?
    private(set) var settingsController: UIViewController?
    
    private(set) var tabBar: UITabBarController?
    
    func makeTabBar(main: UIViewController, admin: UIViewController? = nil, settings: UIViewController) -> UITabBarController {
        var tabBarControllers = [UIViewController]()
        
        mainController = main
        tabBarControllers.append(UINavigationController(rootViewController: main))
        if let admin {
            adminController = admin
            tabBarControllers.append(UINavigationController(rootViewController: admin))
        }
        settingsController = settings
        tabBarControllers.append(UINavigationController(rootViewController: settings))
        
        let tabBar = UITabBarController()
        self.tabBar = tabBar
        tabBar.viewControllers = tabBarControllers
        tabBar.tabBar.backgroundColor = UIColor(resource: .grayAccent)
        
        return tabBar
    }
    
}
