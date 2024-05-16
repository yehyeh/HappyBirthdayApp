//
//  BirthdayPresenter.swift
//  HappyBirthdayApp
//
//  Created by Yehonatan Yehudai on 13/05/2024.
//

import UIKit

protocol BirthdayPresenterProtocol: ImagePickerDelegate {
    func onViewDidLoad()
    func handleImagePickerTapped()
    func handleCameraTapped()
    func shareTapped()
    func dismiss()
}

protocol BirthdayViewProtocol: AnyObject {
    func fill(resources: BabyViewResource)
    func updateImage(image: UIImage)
}

protocol BirthdayCoordinator: AnyObject, ImagePickerCoordinator {
    func dismissBirthday()
}

class BirthdayPresenter: BirthdayPresenterProtocol {
    weak var view: BirthdayViewProtocol?
    weak var coordinator: BirthdayCoordinator?
    weak var inputDelegate: InputPresenterDelegate?
    var persistanceService: PersistanceProtocol!
    var baby: BabyData!

    func onViewDidLoad() {
        view?.fill(resources: viewInitialResources)
    }

    func handleImagePickerTapped() {
        coordinator?.showImagePicker(from: self)
    }
    
    func handleCameraTapped() {
        coordinator?.showCamera(from: self)
    }

    func shareTapped() {
        
    }

    func dismiss() {
        coordinator?.dismissBirthday()
    }
}

extension BirthdayPresenter: ImagePickerDelegate {
    func handleImageSelection(image: UIImage) {
        persistanceService.save(image: image)
        view?.updateImage(image: image)
        inputDelegate?.inputDataHasModified()
    }
}

private extension BirthdayPresenter {
    static var randomTheme: BirthdayTheme {
        switch Int.random(in: 0...2) {
            case 0:
                return .yellow
            case 1:
                return .green
            default:
                return .blue
        }
    }

    var viewInitialResources: BabyViewResource {
        let theme = Self.randomTheme
        baby.image = baby.image ?? UIImage(imageLiteralResourceName: theme.avatarPlaceholderImagePath)
        return BabyViewResource(baby: baby, theme: theme)
    }
}
