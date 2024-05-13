//
//  SceneDelegate.swift
//  HappyBirthdayApp
//
//  Created by Yehonatan Yehudai on 13/05/2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var applicationCoordintor: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let applicationCoordintor = AppCoordinator(window: window)
        applicationCoordintor.start()

        self.applicationCoordintor = applicationCoordintor
        window.makeKeyAndVisible()
    }
}
