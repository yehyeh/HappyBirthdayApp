//
//  AppCoordinator.swift
//  HappyBirthdayApp
//
//  Created by Yehonatan Yehudai on 13/05/2024.
//

import Foundation
import UIKit

class AppCoordinator: NSObject {
    let window: UIWindow
    
    private(set) var rootViewController: UINavigationController

    private lazy var firstViewController: InputViewController = {
        let presenter = InputPresenter()
        let vc = InputViewController(presenter: presenter)
        presenter.view = vc
        presenter.persistanceService = UserDefaultsPersistance()
        presenter.coordinatorDelegate = self
        return vc
    }()

    private lazy var birthdayScreen: BirthdayViewController = {
        let presenter = BirthdayPresenter()
        let vc = BirthdayViewController(presenter: presenter)
        presenter.view = vc
        presenter.persistanceService = UserDefaultsPersistance()
        presenter.coordinatorDelegate = self
        return vc
    }()

    init(window: UIWindow) {
        self.window = window
        self.rootViewController = UINavigationController()
        self.rootViewController.navigationBar.prefersLargeTitles = true
        window.rootViewController = rootViewController
    }
}

extension AppCoordinator: Coordinator {
    func start() {
        rootViewController.setViewControllers([firstViewController], animated: false)
    }
}

extension AppCoordinator: InputCoordinatorDelegate {
    func showBirthday(with data: any BabyData) {
        rootViewController.pushViewController(birthdayScreen, animated: true)
    }
}

extension AppCoordinator: BirthdayCoordinatorDelegate {
    func dismissBirthday() {
        rootViewController.popViewController(animated: true)
    }
}
