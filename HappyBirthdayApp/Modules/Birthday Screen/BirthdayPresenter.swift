//
//  BirthdayPresenter.swift
//  HappyBirthdayApp
//
//  Created by Yehonatan Yehudai on 13/05/2024.
//

import UIKit

protocol BirthdayPresenterProtocol: ImagePickerDelegate {
    func onViewDidLoad()
    func avatarTapped()
    func cameraTapped()
    func shareTapped()
    func backTapped()
}

protocol BirthdayViewProtocol: AnyObject {
    func setupContents(inScreenCaptureMode: Bool)
    func fill(resources: BabyViewResource)
    func updateImage(image: UIImage)
}

protocol BirthdayCoordinator: AnyObject, ImagePickerCoordinator {
    func showBirthdayShareMenu(theme: BirthdayTheme)
    func closeBirthday()
}

class BirthdayPresenter: BirthdayPresenterProtocol {
    weak var view: BirthdayViewProtocol?
    weak var coordinator: BirthdayCoordinator?
    weak var inputDelegate: InputPresenterDelegate?
    private let persistanceService: PersistanceProtocol
    private let isScreenCaptureMode: Bool
    private let theme: BirthdayTheme

    init(view: BirthdayViewProtocol? = nil,
         coordinator: BirthdayCoordinator? = nil,
         inputDelegate: InputPresenterDelegate? = nil,
         persistanceService: PersistanceProtocol,
         theme: BirthdayTheme,
         isScreenCaptureMode: Bool) {
        self.view = view
        self.coordinator = coordinator
        self.inputDelegate = inputDelegate
        self.theme = theme
        self.isScreenCaptureMode = isScreenCaptureMode
        self.persistanceService = persistanceService
    }

    func onViewDidLoad() {
        let baby = persistanceService.load()
        let viewInitialResources: BabyViewResource = .init(baby: baby, theme: theme)
        view?.setupContents(inScreenCaptureMode: isScreenCaptureMode)
        view?.fill(resources: viewInitialResources)
    }

    func avatarTapped() {
        coordinator?.showImagePicker(from: self)
    }
    
    func cameraTapped() {
        coordinator?.showCamera(from: self)
    }

    func shareTapped() {
        coordinator?.showBirthdayShareMenu(theme: theme)
    }

    func backTapped() {
        coordinator?.closeBirthday()
    }
}

extension BirthdayPresenter: ImagePickerDelegate {
    func handleImageSelection(image: UIImage) {
        persistanceService.save(image: image)
        view?.updateImage(image: image)
        inputDelegate?.inputDataHasModified()
    }
}
