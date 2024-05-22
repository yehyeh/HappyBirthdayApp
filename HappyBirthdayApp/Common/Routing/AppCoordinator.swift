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

    private func birthdayScreen(theme: BirthdayTheme, screenCaptureMode: Bool, delegate: InputPresenterDelegate? = nil) -> BirthdayViewController {
        let presenter = BirthdayPresenter(persistanceService: UserDefaultsPersistance(), theme: theme, isScreenCaptureMode: screenCaptureMode)
        let vc = BirthdayViewController(presenter: presenter)
        presenter.view = vc
        presenter.inputDelegate = delegate
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
        let rootVC = UINavigationController()
        self.rootViewController = rootVC
        window.rootViewController = rootViewController
    }
}

extension AppCoordinator: Coordinator {
    func start() {
        rootViewController.delegate = self
        rootViewController.navigationBar.prefersLargeTitles = true
        rootViewController.setViewControllers([firstViewController], animated: false)
    }
}

extension AppCoordinator: InputCoordinator {
    func showImagePicker(from: any ImagePickerDelegate) {
        imagePickerDelegate = from
        present(imagePickerScreen(sourceType: .photoLibrary), animated: true)
    }
    
    func showCamera(from: any ImagePickerDelegate) {
        imagePickerDelegate = from
        present(imagePickerScreen(sourceType: .camera), animated: true)
    }
    
    func showBirthday(delegate: InputPresenterDelegate?) {
        let vc = birthdayScreen(theme: .random(), screenCaptureMode: false, delegate: delegate)
        rootViewController.pushViewController(vc, animated: true)
        rootViewController.setNavigationBarHidden(true, animated: true)
    }
}

extension AppCoordinator: BirthdayCoordinator {
    func showBirthdayShareMenu(theme: BirthdayTheme, sender: UIView) {
        let captureScreen = birthdayScreen(theme: theme, screenCaptureMode: true)
        let shareable = ShareableImage(image: captureScreen.captureAsImage, title: "Check out the news 🥳")

        showShareMenu(for: shareable, sender: sender)
    }

    func closeBirthday() {
        rootViewController.isNavigationBarHidden = false
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

private extension AppCoordinator {
    func present(_ viewControllerToPresent: UIViewController, animated: Bool = true) {
        guard let top = rootViewController.topViewController, top.presentedViewController == nil else { return }
        rootViewController.present(viewControllerToPresent, animated: animated)
    }

    func showShareMenu(for item: UIActivityItemSource, sender: UIView) {
        let activityViewController = UIActivityViewController(activityItems: [item], applicationActivities: nil)
        activityViewController.excludedActivityTypes = []
        let popover = activityViewController.popoverPresentationController
        popover?.sourceView = sender
        popover?.sourceRect = sender.bounds

        present(activityViewController, animated: true)
    }
}
