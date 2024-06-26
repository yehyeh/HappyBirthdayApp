//
//  BabyData.swift
//  HappyBirthdayApp
//
//  Created by Yehonatan Yehudai on 13/05/2024.
//

import UIKit

protocol BabyData {
    var name: String { get set }
    var birthDate: Date? { get set }
    var image: UIImage? { get set }
}

struct Baby: BabyData {
    var name: String = ""
    var birthDate: Date? = nil
    var image: UIImage? = nil
}
