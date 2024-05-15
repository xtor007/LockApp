//
//  FlowFactory.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 15.05.2024.
//

import UIKit

class FlowFactory {
    func makeEnterServerVC() -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = .red
        return vc
    }
}
