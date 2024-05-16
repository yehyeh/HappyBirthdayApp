//
//  AppCoordinator.swift
//  HappyBirthdayApp
//
//  Created by Yehonatan Yehudai on 13/05/2024.
//

import Foundation
import UIKit

protocol ImagePickerDelegate: AnyObject {
    func handleImageSelection(image: UIImage)
}

protocol ImagePickerCoordinator: AnyObject {
    func showImagePicker(from: ImagePickerDelegate)
    func showCamera(from: ImagePickerDelegate)
}

class AppCoordinator: NSObject {
    let window: UIWindow
    weak var imagePickerDelegate: ImagePickerDelegate? = nil

    private(set) var rootViewController: UINavigationController

    private lazy var firstViewController: InputViewController = {
        let presenter = InputPresenter()
        let vc = InputViewController(presenter: presenter)
        presenter.view = vc
        presenter.persistanceService = UserDefaultsPersistance()
        presenter.coordinator = self
        return vc
    }()

    private func birthdayScreen(with data: any BabyData, delegate: InputPresenterDelegate) -> BirthdayViewController {
        let presenter = BirthdayPresenter()
        let vc = BirthdayViewController(presenter: presenter)
        presenter.view = vc
        presenter.baby = data
        presenter.inputDelegate = delegate
        presenter.persistanceService = UserDefaultsPersistance()
        presenter.coordinator = self
        return vc
    }

    private func makeUIViewController(sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {

        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self

        return imagePicker
    }

    private func imagePickerScreen(sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
        makeUIViewController(sourceType: sourceType)
    }

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

extension AppCoordinator: InputCoordinator {
    func showImagePicker(from: any ImagePickerDelegate) {

    }
    
    func showCamera(from: any ImagePickerDelegate) {

    }
    
    func showBirthday(with data: any BabyData, delegate: InputPresenterDelegate) {
        let vc = birthdayScreen(with: data, delegate: delegate)
        
        rootViewController.pushViewController(vc, animated: true)
    }
}

extension AppCoordinator: BirthdayCoordinator {
    func dismissBirthday() {
        rootViewController.popViewController(animated: true)
    }
}

extension AppCoordinator: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickerDelegate?.handleImageSelection(image: image)
            imagePickerDelegate = nil
        }

        rootViewController.presentedViewController?.dismiss(animated: true)
    }
}
