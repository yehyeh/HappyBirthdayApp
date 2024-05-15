//
//  InputPresenter.swift
//  HappyBirthdayApp
//
//  Created by Yehonatan Yehudai on 13/05/2024.
//

import UIKit

protocol InputPresenterProtocol {
    func onViewDidLoad()
    func handleNameChanged(name: String)
    func handleBirthDateChanged(date: Date)
    func handleImageSelection(image: UIImage)
    func handleShowBirthdayTap()
}

protocol InputViewProtocol: AnyObject {
    func update(baby: BabyData)
    func updateImage(image: UIImage?)
    func updateNextScreenButtonState()
}

protocol InputCoordinatorDelegate: AnyObject {
    func showBirthday(with data: BabyData)
}

protocol PersistanceProtocol: AnyObject {
    func load() -> BabyData
    func save(name: String)
    func save(date: Date)
    func save(image: UIImage)
}

class InputPresenter: InputPresenterProtocol {
    weak var view: InputViewProtocol?
    weak var coordinatorDelegate: InputCoordinatorDelegate?
    var persistanceService: PersistanceProtocol!

    func onViewDidLoad() {
        let baby = persistanceService.load()
        view?.update(baby: baby)
    }

    func handleNameChanged(name: String) {
        persistanceService.save(name: name)
        view?.updateNextScreenButtonState()
    }

    func handleBirthDateChanged(date: Date) {
        persistanceService.save(date: date)
    }

    func handleImageSelection(image: UIImage) {
        persistanceService.save(image: image)
    }

    func handleShowBirthdayTap() {
        coordinatorDelegate?.showBirthday(with: Baby())
    }
}
