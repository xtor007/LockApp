//
//  SceneDelegate.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 14.05.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let flow = Flow()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        flow.executor = self
        flow.start()
        
        ThemeManager.shared.applyTheme()
    }

}

extension SceneDelegate: FlowExecutor {
    func showVC(_ vc: UIViewController) {
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
}
