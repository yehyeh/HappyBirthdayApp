//
//  InputPresenter.swift
//  HappyBirthdayApp
//
//  Created by Yehonatan Yehudai on 13/05/2024.
//

import UIKit

protocol InputPresenterProtocol: ImagePickerDelegate {
    func onViewDidLoad()
    func onViewWillAppear()
    func handleNameChanged(name: String)
    func handleBirthDateChanged(date: Date)
    func handleAvatarTapped()
    func handleShowBirthdayTap()
}

protocol InputPresenterDelegate: AnyObject {
    func inputDataHasModified()
}

protocol InputViewProtocol: AnyObject {
    func update(baby: BabyData)
    func updateImage(image: UIImage?)
    func updateNextScreenButtonState()
}

protocol InputCoordinator: AnyObject, ImagePickerCoordinator {
    func showBirthday(delegate: InputPresenterDelegate?)
}

protocol PersistanceProtocol: AnyObject {
    func load() -> BabyData
    func save(name: String)
    func save(date: Date)
    func save(image: UIImage)
}

class InputPresenter: InputPresenterProtocol {
    weak var view: InputViewProtocol?
    weak var coordinator: InputCoordinator?
    var persistanceService: PersistanceProtocol!
    private var imageGotUpdated: Bool = false

    func onViewDidLoad() {
        let baby = persistanceService.load()
        view?.update(baby: baby)
    }

    func onViewWillAppear() {
        if imageGotUpdated {
            let baby = persistanceService.load()
            view?.updateImage(image: baby.image)
            imageGotUpdated = false
        }
    }

    func handleNameChanged(name: String) {
        persistanceService.save(name: name)
        view?.updateNextScreenButtonState()
    }

    func handleBirthDateChanged(date: Date) {
        persistanceService.save(date: date)
    }

    func handleAvatarTapped() {
        coordinator?.showImagePicker(from: self)
    }

    func handleShowBirthdayTap() {
        coordinator?.showBirthday(delegate: self)
    }
}

extension InputPresenter: ImagePickerDelegate {
    func handleImageSelection(image: UIImage) {
        view?.updateImage(image: image)
        persistanceService.save(image: image)
    }
}

extension InputPresenter: InputPresenterDelegate {
    func inputDataHasModified() {
        imageGotUpdated = true
    }
}
