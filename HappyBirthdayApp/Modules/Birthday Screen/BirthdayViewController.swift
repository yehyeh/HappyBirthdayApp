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
    @IBOutlet weak var cameraImageView: UIImageView!
    @IBOutlet weak var cameraImageViewCenterX: NSLayoutConstraint!
    @IBOutlet weak var cameraImageViewCenterY: NSLayoutConstraint!

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
        avatarImageView.layer.cornerRadius = avatarImageView.boundsRadius

        // Position camera option: r*cos(45)
        let cordinates = (avatarImageView.frame.width/2) * pow(2, 0.5) / 2.0
        cameraImageViewCenterX.constant = cordinates
        cameraImageViewCenterY.constant = -cordinates
    }

    // MARK: - Handlers
    @objc private func cameraImageTapped(gesture: UIGestureRecognizer) {
        UIView.animateOnTap(gesture: gesture, completion: { [weak self] _ in
            self?.presenter.cameraTapped()
        })
    }

    @objc private func avatarImageTapped(gesture: UIGestureRecognizer) {
        UIView.animateOnTap(gesture: gesture, completion: { [weak self] _ in
            self?.presenter?.avatarTapped()
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
    var captureAsImage: UIImage {
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)

        let image = renderer.image { context in
            view.layer.render(in: context.cgContext)
        }

        return image
    }

    func setupContents(interactable: Bool) {
        if !interactable {
            backButton.isHidden = true
            shareButton.isHidden = true
            cameraImageView.isHidden = true
            return
        }
        backButton.tintColor = UIColor(hex: "394562")

        let swipeBackGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleSwipeBackGesture(_:)))
        swipeBackGesture.edges = .left
        view.addGestureRecognizer(swipeBackGesture)

        let avatarTapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarImageTapped))
        avatarImageView.addGestureRecognizer(avatarTapGesture)

        let camTapGesture = UITapGestureRecognizer(target: self, action: #selector(cameraImageTapped))
        cameraImageView.addGestureRecognizer(camTapGesture)
    }

    func fill(resources: BabyViewResource) {
        let theme = resources.theme
        view.backgroundColor = theme.backgroundColor

        headerTopLabel.text = resources.headerTopText.uppercased()
        headerBottomLabel.text = resources.headerBottomText.uppercased()

        foregroundImageView.image = UIImage(named: theme.foregroundImagePath)
        numericImageView.image = UIImage(named: resources.headerAgeImagePath)
        cameraImageView.image = UIImage(named: theme.cameraImagePath)

        if let image = resources.baby.image {
            avatarImageView.image = image
            avatarImageView.layer.borderWidth = 6
            avatarImageView.layer.borderColor = theme.borderColor.cgColor
        } else {
            avatarImageView.image = UIImage(named: theme.avatarPlaceholderImagePath)
        }

        shareButton.setTitle(resources.shareButtonText, for: .normal)
    }

    func updateImage(image: UIImage) {
        avatarImageView.image = image
    }
}
