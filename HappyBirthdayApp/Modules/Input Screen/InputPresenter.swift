//
//  InputPresenter.swift
//  HappyBirthdayApp
//
//  Created by Yehonatan Yehudai on 13/05/2024.
//

import UIKit

protocol InputPresenterProtocol {
    func handleShowBirthdayTap()
}

protocol InputViewProtocol: AnyObject {
}

protocol InputCoordinatorDelegate: AnyObject {
    func showBirthday(with data: BabyData)
}

class InputPresenter: InputPresenterProtocol {
    weak var view: InputViewProtocol?
    weak var coordinatorDelegate: InputCoordinatorDelegate?

    func handleShowBirthdayTap() {
        coordinatorDelegate?.showBirthday(with: Baby())
    }
}
