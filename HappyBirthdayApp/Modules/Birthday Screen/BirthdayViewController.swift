//
//  BirthdayViewController.swift
//  HappyBirthdayApp
//
//  Created by Yehonatan Yehudai on 13/05/2024.
//

import UIKit

class BirthdayViewController: UIViewController, BirthdayViewProtocol {
    private var presenter: BirthdayPresenter!

    init(presenter: BirthdayPresenter) {
        self.presenter = presenter
        super.init(nibName: "BirthdayViewController", bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateImage(image: UIImage?) {

    }
}
