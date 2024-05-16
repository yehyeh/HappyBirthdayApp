//
//  AppLabel.swift
//  HappyBirthdayApp
//
//  Created by Yehonatan Yehudai on 16/05/2024.
//

import UIKit

class AppLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        self.textColor = UIColor(hex: "394562")
    }
}
