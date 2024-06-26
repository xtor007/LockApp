//
//  TabBarMaker.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 16.05.2024.
//

import SwiftUI

class TabBarMaker {
    
    private(set) var mainController: UIViewController?
    private(set) var adminController: UIViewController?
    private(set) var settingsController: UIViewController?
    
    private(set) var addController: UIViewController?
    
    private(set) var userController: UIViewController?
    
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
    
    private func showLogs(from vc: UIViewController?, with viewModel: LogsViewModel) {
        let logsVC = UIHostingController(rootView: LogsView(viewModel: viewModel))
        logsVC.hidesBottomBarWhenPushed = true
        vc?.navigationController?.pushViewController(logsVC, animated: true)
    }
    
}

extension TabBarMaker: MainShower, AdminShowerDelegate, UserShower {
    func showAddNewEmployer(_ department: String?) {
        let viewModel = AddViewModel(department: department) { [weak self] in
            guard let self else { return }
            addController?.navigationController?.popViewController(animated: true)
            addController = nil
        }
        let vc = UIHostingController(rootView: AddView(viewModel: viewModel))
        vc.hidesBottomBarWhenPushed = true
        addController = vc
        adminController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showLogsFromMain(_ viewModel: LogsViewModel) {
        guard tabBar?.selectedIndex == 0 else { return }
        showLogs(from: mainController, with: viewModel)
    }
    
    func showUserScreen(_ viewModel: UserViewModel) {
        guard tabBar?.selectedIndex == 1 else { return }
        let vc = UIHostingController(rootView: UserView(viewModel: viewModel))
        viewModel.shower = self
        vc.hidesBottomBarWhenPushed = true
        userController = vc
        adminController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showLogsFromAdmin(_ viewModel: LogsViewModel) {
        guard tabBar?.selectedIndex == 1 else { return }
        showLogs(from: adminController, with: viewModel)
    }
    
    func dismissUser() {
        userController?.navigationController?.popViewController(animated: true)
        userController = nil
    }
}
