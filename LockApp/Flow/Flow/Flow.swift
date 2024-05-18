//
//  Flow.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 15.05.2024.
//

import UIKit

class Flow {
    
    weak var executor: FlowExecutor!
    
    private let factory = FlowFactory()
    
    // MARK: - Screens
    
    private var enterServerViewModel: EnterServerViewModel?
    private var loadingViewModel: LoadingViewModel?
    private var registrationViewModel: RegistrationViewModel?
    private var registrationVC: UIViewController?
    
    private var changePasswordViewModel: ChangePasswordViewModel?
    private var changePasswordVC: UIViewController?
    
    private var tabBarMaker: TabBarMaker?
    private var mainViewModel: MainViewModel?
    private var settingsViewModel: SettingsViewModel?
    private var adminViewModel: AdminViewModel?
    
    // MARK: - Life
    
    func start() {
        subscribeToNotifications()
        changeScreenWhenServerLinkUpdated()
    }
    
    private func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(changeScreenWhenServerLinkUpdated), name: .serverLinkChanged, object: nil)
    }
}

// MARK: - Logic

extension Flow {
    @objc func changeScreenWhenServerLinkUpdated() {
        if UserDefaults.serverLink == nil {
            showEnterServer()
        } else {
            showLoading { [weak self] in
                guard let self else { return }
                goToRegistrationOrMain()
            }
        }
    }
    
    private func goToRegistrationOrMain() {
        if NetworkMonitor().checkInternetConnectivity() {
            if UserDefaults.expirationDate ?? .distantFuture > .now {
                refreshToken()
            } else {
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    showMain()
                }
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                if UserDefaults.userInfo == nil {
                    showRegistration()
                } else {
                    showMain()
                }
            }
        }
    }
    
    private func refreshToken() {
        TokenRefresher().refreshToken { result in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                switch result {
                case .success(_):
                    showMain()
                case .failure(let error):
                    print(error)
                    showRegistration()
                }
            }
        }
    }
    
    private func refreshData() {
        DataRefresher().refreshData { result in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                switch result {
                case .success(_):
                    showMain()
                case .failure(let error):
                    print(error)
                    showRegistration()
                }
            }
        }
    }
    
    private func clearPrepareMemory() {
        enterServerViewModel = nil
        loadingViewModel = nil
        registrationViewModel = nil
        registrationVC = nil
    }
    
    private func clearMainMemory() {
        tabBarMaker = nil
        mainViewModel = nil
        settingsViewModel = nil
        adminViewModel = nil
    }
}

// MARK: - Show screen

extension Flow: RegistrationShowerDelegate, SettingsShowerDelegate {
    func showEnterServer() {
        let enterServerViewModel = self.enterServerViewModel ?? EnterServerViewModel()
        self.enterServerViewModel = enterServerViewModel
        let vc = factory.makeEnterServerVC(enterServerViewModel)
        executor.showVC(vc)
    }
    
    func showLoading(task: @escaping () -> Void) {
        let loadingViewModel = LoadingViewModel(task: task)
        self.loadingViewModel = loadingViewModel
        let vc = factory.makeLoadingVC(loadingViewModel)
        executor.showVC(vc)
    }
    
    func showRegistration() {
        let registrationViewModel = RegistrationViewModel(delegate: self)
        self.registrationViewModel = registrationViewModel
        let vc = factory.makeRegistrationVC(registrationViewModel)
        self.registrationVC = vc
        executor.showVC(vc)
        clearMainMemory()
    }
    
    func showChangePasswordFromRegistration() {
        showChangePassword(from: registrationVC)
    }
    
    func openChangePasswordFromSettings() {
        showChangePassword(from: tabBarMaker?.settingsController, UserDefaults.userInfo?.email)
    }
    
    func showChangePassword(from vc: UIViewController?, _ email: String? = nil) {
        let changePasswordViewModel = ChangePasswordViewModel { [weak self] in
            guard let self else { return }
            self.changePasswordVC?.navigationController?.popViewController(animated: true)
            self.changePasswordVC = nil
            self.changePasswordViewModel = nil
        }
        changePasswordViewModel.email = email ?? ""
        self.changePasswordViewModel = changePasswordViewModel
        let changePasswordVC = factory.makeChangePasswordVC(changePasswordViewModel)
        self.changePasswordVC = changePasswordVC
        changePasswordVC.hidesBottomBarWhenPushed = true
        let navigation = (vc as? UINavigationController) ?? vc?.navigationController
        navigation?.pushViewController(changePasswordVC, animated: true)
    }
    
    func showMain() {
        guard let info = UserDefaults.userInfo else {
            showLoading { [weak self] in
                guard let self else { return }
                refreshData()
            }
            return
        }
        showTabBar(info)
    }
    
    func showTabBar(_ user: EmployerModel) {
        let tabBarMaker = TabBarMaker()
        self.tabBarMaker = tabBarMaker
        
        let mainVC = createMainVC()
        let adminVC = (UserDefaults.userInfo?.isAdmin ?? false) ? createAdminVC() : nil
        let settingsVC = createSettingsVC(user)
        
        let tabBarVC = tabBarMaker.makeTabBar(main: mainVC, admin: adminVC, settings: settingsVC)
        executor.showVC(tabBarVC)
        
        mainViewModel?.showerDelegate = tabBarMaker
        adminViewModel?.showerDelegate = tabBarMaker
        
        clearPrepareMemory()
    }
    
}

// MARK: - Create

extension Flow {
    private func createMainVC() -> UIViewController {
        let mainViewModel = MainViewModel()
        self.mainViewModel = mainViewModel
        let mainVC = factory.makeMainVC(mainViewModel)
        return mainVC
    }
    
    private func createSettingsVC(_ user: EmployerModel) -> UIViewController {
        let settingsViewModel = SettingsViewModel(user: user)
        self.settingsViewModel = settingsViewModel
        settingsViewModel.showerDelegate = self
        let settingsVC = factory.makeSettingsVC(settingsViewModel)
        return settingsVC
    }
    
    private func createAdminVC() -> UIViewController {
        let adminViewModel = AdminViewModel()
        self.adminViewModel = adminViewModel
        let adminVC = factory.makeAdminVC(adminViewModel)
        return adminVC
    }
}
