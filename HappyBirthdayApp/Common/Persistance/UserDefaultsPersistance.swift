//
//  UserDefaultsPersistance.swift
//  HappyBirthdayApp
//
//  Created by Yehonatan Yehudai on 14/05/2024.
//

import UIKit

class UserDefaultsPersistance: PersistanceProtocol {
    private var defaults = UserDefaults.standard
    
    func load() -> (any BabyData) {
        let name = defaults.string(forKey: "name") ?? ""
        let date = defaults.object(forKey: "birthDate") as? Date
        var image: UIImage?
        if let imageData = defaults.data(forKey: "image") {
            image = UIImage(data: imageData)
        }
        return Baby(name: name, birthDate: date, image: image)
    }

    func save(name: String) {
        defaults.setValue(name, forKey: "name")
    }
    
    func save(date: Date) {
        defaults.setValue(date, forKey: "birthDate")
    }
    
    func save(image: UIImage) {
        guard let imageData = image.pngData() else { return }
        defaults.setValue(imageData, forKey: "image")
    }
}
