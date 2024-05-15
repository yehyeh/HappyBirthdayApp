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
    func handleChangeAvatarTapped()
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
    func showBirthday(with data: BabyData, delegate: InputPresenterDelegate)
}

protocol PersistanceProtocol: AnyObject {
    func load() -> BabyData
    func save(name: String)
    func save(date: Date)
    func save(image: UIImage)
}

class InputPresenter: InputPresenterProtocol {
    weak var view: InputViewProtocol?
    weak var Coordinator: InputCoordinator?
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

    func handleChangeAvatarTapped() {
        Coordinator?.showPhotoPicker(from: self)
    }

    func handleShowBirthdayTap() {
        let baby = persistanceService.load()
        Coordinator?.showBirthday(with: baby, delegate: self)
    }

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
