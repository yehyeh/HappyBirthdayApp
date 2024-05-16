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
    func setupContents()
    func fill(resources: BabyViewResource)
//    func hideNavigationBar()
//    func resetNavigationBarVisibility()
    func updateImage(image: UIImage)
}

protocol BirthdayCoordinator: AnyObject, ImagePickerCoordinator {
    func closeBirthday()
}

class BirthdayPresenter: BirthdayPresenterProtocol {
    weak var view: BirthdayViewProtocol?
    weak var coordinator: BirthdayCoordinator?
    weak var inputDelegate: InputPresenterDelegate?
    private let persistanceService: PersistanceProtocol
    private(set) var baby: BabyData

    init(view: BirthdayViewProtocol? = nil,
         coordinator: BirthdayCoordinator? = nil,
         inputDelegate: InputPresenterDelegate? = nil,
         persistanceService: PersistanceProtocol,
         baby: BabyData) {
        self.view = view
        self.coordinator = coordinator
        self.inputDelegate = inputDelegate
        self.persistanceService = persistanceService
        self.baby = baby
    }

    func onViewDidLoad() {
        view?.setupContents()
        view?.fill(resources: viewInitialResources)
    }

    func avatarTapped() {
        coordinator?.showImagePicker(from: self)
    }
    
    func cameraTapped() {
        coordinator?.showCamera(from: self)
    }

    func shareTapped() {

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
