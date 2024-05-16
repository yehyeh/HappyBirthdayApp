//
//  BirthdayViewController.swift
//  HappyBirthdayApp
//
//  Created by Yehonatan Yehudai on 13/05/2024.
//

import UIKit

class BirthdayViewController: UIViewController {
    private var presenter: BirthdayPresenter!

    @IBOutlet weak var foregroundImageView: UIImageView!
    @IBOutlet weak var headerTopLabel: UILabel!
    @IBOutlet weak var numericImageView: UIImageView!
    @IBOutlet weak var headerBottomLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!

    init(presenter: BirthdayPresenter) {
        self.presenter = presenter
        super.init(nibName: "BirthdayViewController", bundle: .main)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.onViewDidLoad()
    }
    
    @IBAction func shareButtonTapped() {
        presenter.shareTapped()
    }
}
extension BirthdayViewController: BirthdayViewProtocol {
    func fill(resources: BabyViewResource) {
        view.backgroundColor = resources.theme.backgroundColor
        foregroundImageView.image = UIImage(imageLiteralResourceName: resources.theme.foregroundImagePath)
        headerTopLabel.text = resources.headerTopText
        numericImageView.image = UIImage(imageLiteralResourceName: resources.headerAgeImagePath)
        headerBottomLabel.text = resources.headerBottomText
        avatarImageView.image = resources.baby.image
        shareButton.setTitle(resources.shareButtonText, for: .normal)
    }

    func updateImage(image: UIImage) {
        avatarImageView.image = image
    }
}
