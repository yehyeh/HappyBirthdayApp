//
//  BirthdayPresenter.swift
//  HappyBirthdayApp
//
//  Created by Yehonatan Yehudai on 13/05/2024.
//

import UIKit

protocol BirthdayPresenterProtocol {
    func handleImageSelection(image: UIImage?)
    func dismiss()
}

protocol BirthdayViewProtocol: AnyObject {
    func updateImage(image: UIImage?)
}

protocol BirthdayCoordinatorDelegate: AnyObject {
    func dismissBirthday()
}

class BirthdayPresenter: BirthdayPresenterProtocol {
    weak var view: BirthdayViewProtocol?
    weak var coordinatorDelegate: BirthdayCoordinatorDelegate?

    func handleImageSelection(image: UIImage?) {

    }

    func dismiss() {
        coordinatorDelegate?.dismissBirthday()
    }
}
