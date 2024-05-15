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
    
    // MARK: - Life
    
    func start() {
        subscribeToNotifications()
        changeScreenWhenServerLinkUpdated()
    }
    
    private func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(changeScreenWhenServerLinkUpdated), name: .serverLinkChanged, object: nil)
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
}

// MARK: - Notification

extension Flow {
    @objc func changeScreenWhenServerLinkUpdated() {
        if UserDefaults.serverLink == nil {
            showEnterServer()
        } else {
            showEnterServer() // FIXME: delete
        }
    }
}
