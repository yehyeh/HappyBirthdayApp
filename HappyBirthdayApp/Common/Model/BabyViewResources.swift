//
//  BabyViewResources.swift
//  HappyBirthdayApp
//
//  Created by Yehonatan Yehudai on 16/05/2024.
//

import Foundation

struct BabyViewResource {
    var baby: BabyData
    var theme: BirthdayTheme
    var headerTopText: String { "Today \(baby.name) is" + zeroMonthsHeaderTopTextHandler }
    var headerAgeImagePath: String { Self.numericImagePath(birthdayCalculation.amount) }
    var zeroMonthsHeaderTopTextHandler: String {
        (birthdayCalculation.amount == 0) ? " almost" : ""
    }
    var headerBottomText: String { "\(birthdayCalculation.unit) old!" }
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
    var shareButtonText: String { "Share the news" }
    static func numericImagePath(_ number: Int) -> String {
        guard (1...12).contains(number) else {
            guard number == 0 else { return "" }
            return "1"
        }
        return "\(number)"
    }
}
