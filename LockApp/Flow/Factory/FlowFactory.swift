//
//  FlowFactory.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 15.05.2024.
//

import SwiftUI

class FlowFactory {
    func makeEnterServerVC(_ viewModel: EnterServerViewModel) -> UIViewController {
        let vc = UIHostingController(rootView: EnterServerView(viewModel: viewModel))
        return vc
    }
    
    func makeLoadingVC(_ viewModel: LoadingViewModel) -> UIViewController {
        let vc = UIHostingController(rootView: LoadingView(viewModel: viewModel))
        return vc
    }
    
    func makeRegistrationVC(_ viewModel: RegistrationViewModel) -> UIViewController {
        let vc = UIHostingController(rootView: RegistrationView(viewModel: viewModel))
        let navigation = UINavigationController(rootViewController: vc)
        return navigation
    }
    
    func makeChangePasswordVC(_ viewModel: ChangePasswordViewModel) -> UIViewController {
        let vc = UIHostingController(rootView: ChangePasswordView(viewModel: viewModel))
        return vc
    }
    
    func makeMainVC(_ viewModel: MainViewModel) -> UIViewController {
        let vc = UIHostingController(rootView: MainView(viewModel: viewModel))
        vc.tabBarItem = UITabBarItem(
            title: Texts.Main.info.rawValue,
            image: UIImage(systemName: "info.bubble"),
            tag: 0
        )
        return vc
    }
    
    func makeAdminVC(_ viewModel: AdminViewModel) -> UIViewController {
        let vc = UIHostingController(rootView: AdminView(viewModel: viewModel))
        vc.tabBarItem = UITabBarItem(
            title: Texts.Admin.admin.rawValue,
            image: UIImage(systemName: "list.bullet.clipboard.fill"),
            tag: 0
        )
        return vc
    }
    
    func makeSettingsVC(_ viewModel: SettingsViewModel) -> UIViewController {
        let vc = UIHostingController(rootView: SettingsView(viewModel: viewModel))
        vc.tabBarItem = UITabBarItem(
            title: Texts.Settings.settings.rawValue,
            image: UIImage(systemName: "gear.circle.fill"),
            tag: 0
        )
        return vc
    }
}
