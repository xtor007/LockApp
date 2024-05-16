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
        return vc
    }
}
