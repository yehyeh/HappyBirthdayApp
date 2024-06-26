//
//  BirthdayTheme.swift
//  HappyBirthday
//
//  Created by Yehonatan Yehudai on 03/05/2024.
//

import UIKit

enum BirthdayTheme {
    case yellow
    case blue
    case green

    var borderColor: UIColor {
        switch self {
            case .yellow:
                return UIColor(hex: "F9BE22")
            case .blue:
                return UIColor(hex: "8BD3E4")
            case .green:
                return UIColor(hex: "6DC4AD")
        }
    }

    var backgroundColor: UIColor {
        switch self {
            case .yellow:
                return UIColor(hex: "FEEFCB")
            case .blue:
                return UIColor(hex: "DAF1F6")
            case .green:
                return UIColor(hex: "C5E8DF")
        }
    }

    var avatarPlaceholderImagePath: String {
        switch self {
            case .yellow:
                return "placeholder.border.yellow"
            case .blue:
                return "placeholder.border.blue"
            case .green:
                return "placeholder.border.green"
        }
    }

    var foregroundImagePath: String {
        switch self {
            case .yellow:
                return "background.elephant"
            case .blue:
                return "background.pelican"
            case .green:
                return "background.fox"
        }
    }

    var cameraImagePath: String {
        switch self {
            case .yellow:
                return "camera.yellow"
            case .blue:
                return "camera.blue"
            case .green:
                return "camera.green"
        }
    }
    
    static func random() -> BirthdayTheme {
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
