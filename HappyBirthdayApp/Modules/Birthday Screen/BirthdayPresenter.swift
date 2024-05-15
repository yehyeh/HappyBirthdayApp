//
//  BirthdayPresenter.swift
//  HappyBirthdayApp
//
//  Created by Yehonatan Yehudai on 13/05/2024.
//

import UIKit

protocol BirthdayPresenterProtocol: ImagePickerDelegate {
    func dismiss()
}

protocol BirthdayViewProtocol: AnyObject {
    func updateImage(image: UIImage?)
}

protocol BirthdayCoordinator: AnyObject, ImagePickerCoordinator {
    func dismissBirthday()
}

class BirthdayPresenter: BirthdayPresenterProtocol {
    weak var view: BirthdayViewProtocol?
    weak var Coordinator: BirthdayCoordinator?
    var persistanceService: PersistanceProtocol!
    var baby: BabyData!

    func handleImageSelection(image: UIImage) {
        view?.updateImage(image: image)
    }

    func dismiss() {
        Coordinator?.dismissBirthday()
    }
}

private extension BirthdayPresenter {
    // MARK: - Resources

    static func numericImagePath(_ number: Int) -> String {
        guard (1...12).contains(number) else {
            guard number == 0 else { return "" }
            return "1"
        }
        return "\(number)"
    }

    var zeroMonthsHeaderTopTextHandler: String {
        (birthdayCalculation.amount == 0) ? " almost" : ""
    }

    var birthdayCalculation: (amount: Int, unit: String) {
        guard let birthdate = baby.birthDate else { return (0, "") }
        let months = birthdate.monthsSinceNow()

        switch months {
            case 0:
                return (amount: 0, unit: "MONTH")

            case 1:
                return (amount: months, unit: "MONTH")

            case 2...11:
                return (amount: months, unit: "MONTHS")

            default:
                let years = months/12
                return (amount: years, unit: (years == 1) ? "YEAR": "YEARS")
        }
    }

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
}

extension Date {
    func monthsSinceNow() -> Int {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month], from: self, to: now)
        return (components.year ?? 0) * 12 + (components.month ?? 0)
    }
}
