//
//  SceneDelegate.swift
//  FindingVehicles
//
//  Created by toka mohsen on 05/12/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    private var window: UIWindow? {
        return coordinator.window
    }


    // MARK: - Dependencies
    private let coordinator: ApplicationCoordinator = ApplicationCoordinator()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }
        coordinator.start(windowScene: windowScene)
    }
}
