//
//  BirthdayViewController.swift
//  HappyBirthdayApp
//
//  Created by Yehonatan Yehudai on 13/05/2024.
//

import UIKit

class BirthdayViewController: UIViewController, BirthdayViewProtocol {
    private var presenter: BirthdayPresenter!

    @IBOutlet weak var foregroundImageView: UIImageView!
    @IBOutlet weak var headerTopLabel: UILabel!
    @IBOutlet weak var numericImageView: UIImageView!
    @IBOutlet weak var headerBottomLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBAction func shareButtonTapped() {
    }

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
