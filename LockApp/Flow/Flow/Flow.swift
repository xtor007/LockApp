//
//  Flow.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 15.05.2024.
//

import Foundation

class Flow {
    
    weak var executor: FlowExecutor!
    
    private let factory = FlowFactory()
    
    // MARK: - Screens
    
    private var enterServerViewModel: EnterServerViewModel?
    private var loadingViewModel: LoadingViewModel?
    
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
                DispatchQueue.main.async {
                    // Main
                }
            }
        } else {
            DispatchQueue.main.async {
                if UserDefaults.userInfo == nil {
                    // Reg
                } else {
                    // Main
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
                    ()
                    // Main
                case .failure(let error):
                    print(error)
                    // Reg
                }
            }
        }
    }
}

// MARK: - Show screen

extension Flow {
    func showEnterServer() {
        let enterServerViewModel = EnterServerViewModel()
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
}
