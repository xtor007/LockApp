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
}
