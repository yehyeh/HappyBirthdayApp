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
    var headerTopText: String { "Today \(baby.name) is" }
    var headerAgeImagePath: String { Self.numericImagePath(birthdayCalculation.amount) }
    var headerBottomText: String { "\(birthdayCalculation.unit) old!" }
    var birthdayCalculation: (amount: Int, unit: String) {
        guard let birthdate = baby.birthDate else { return (0, "") }
        let months = birthdate.monthsSinceNow()

        switch months {
            case 1:
                return (amount: months, unit: "MONTH")

            case 0,2...11:
                return (amount: months, unit: "MONTHS")

            default:
                let years = months/12
                return (amount: years, unit: (years == 1) ? "YEAR": "YEARS")
        }
    }
    var shareButtonText: String { "Share the news" }
    static func numericImagePath(_ number: Int) -> String {
        guard (0...12).contains(number) else {
            return "1"
        }
        return "\(number)"
    }
}
