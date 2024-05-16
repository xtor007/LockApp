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
    }
}

// MARK: - Show screen

extension Flow: RegistrationShowerDelegate {
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
    
    func showChangePassword(from vc: UIViewController?) {
        let changePasswordViewModel = ChangePasswordViewModel { [weak self] in
            guard let self else { return }
            self.changePasswordVC?.navigationController?.popViewController(animated: true)
            self.changePasswordVC = nil
            self.changePasswordViewModel = nil
        }
        self.changePasswordViewModel = changePasswordViewModel
        let changePasswordVC = factory.makeChangePasswordVC(changePasswordViewModel)
        self.changePasswordVC = changePasswordVC
        let navigation = (vc as? UINavigationController) ?? vc?.navigationController
        navigation?.pushViewController(changePasswordVC, animated: true)
    }
    
    func showMain() {
        if UserDefaults.userInfo == nil {
            showLoading { [weak self] in
                guard let self else { return }
                refreshData()
            }
            return
        }
        showTabBar()
    }
    
    func showTabBar() {
        let tabBarMaker = TabBarMaker()
        self.tabBarMaker = tabBarMaker
        
        let mainVC = factory.makeMainVC()
        let adminVC = (UserDefaults.userInfo?.isAdmin ?? false) ? factory.makeAdminVC() : nil
        let settingsVC = factory.makeSettingsVC()
        
        let tabBarVC = tabBarMaker.makeTabBar(main: mainVC, admin: adminVC, settings: settingsVC)
        executor.showVC(tabBarVC)
        
        clearPrepareMemory()
    }
    
}
