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
    @IBOutlet weak var backButton: UIButton!

    // MARK: - Life Cycle
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let rect = avatarImageView.frame
        avatarImageView.layer.cornerRadius = min(rect.width, rect.height) / 2
    }

    // MARK: - Handlers
    @objc private func avatarImageTapped(gesture: UIGestureRecognizer) {
        guard let sender = gesture.view else { return }

        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            sender.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                sender.transform = .identity
            }) { [weak self] _ in
                self?.presenter?.avatarTapped()
            }
        })
    }

    @IBAction func shareButtonTapped() {
        presenter.shareTapped()
    }

    @IBAction func backButtonTapped() {
        presenter.backTapped()
    }

    @objc private func handleSwipeBackGesture(_ gesture: UIScreenEdgePanGestureRecognizer) {
        if gesture.state == .recognized {
            navigationController?.popViewController(animated: true)
        }
    }
}

extension BirthdayViewController: BirthdayViewProtocol {
    func setupContents() {
        backButton.tintColor = UIColor(hex: "394562")

        let swipeBackGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleSwipeBackGesture(_:)))
        swipeBackGesture.edges = .left
        view.addGestureRecognizer(swipeBackGesture)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarImageTapped))
        avatarImageView.addGestureRecognizer(tapGesture)
    }

    func fill(resources: BabyViewResource) {
        let theme = resources.theme
        view.backgroundColor = theme.backgroundColor
        foregroundImageView.image = UIImage(imageLiteralResourceName: theme.foregroundImagePath)
        headerTopLabel.text = resources.headerTopText.uppercased()
        numericImageView.image = UIImage(imageLiteralResourceName: resources.headerAgeImagePath)
        headerBottomLabel.text = resources.headerBottomText.uppercased()
        if let image = resources.baby.image {
            avatarImageView.image = image
            avatarImageView.layer.borderWidth = 6
            avatarImageView.layer.borderColor = theme.borderColor.cgColor
        } else {
            avatarImageView.image = UIImage(imageLiteralResourceName: theme.avatarPlaceholderImagePath)
        }
        shareButton.setTitle(resources.shareButtonText, for: .normal)
    }

    func updateImage(image: UIImage) {
        avatarImageView.image = image
    }
}
