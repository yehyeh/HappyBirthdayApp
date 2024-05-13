//
//  InputViewController.swift
//  HappyBirthdayApp
//
//  Created by Yehonatan Yehudai on 13/05/2024.
//

import UIKit

class Baby: BabyData {
    var name: String = ""
    var birthDate: Date = Date()
    var image: UIImage? = nil
}

class InputViewController: UIViewController, InputViewProtocol {
    private var presenter: InputPresenterProtocol!

    private lazy var nextScreenButton: UIButton = {
        let button = UIButton()
        button.setTitle("Show Birthday Screen", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(showBirthdayButtonTapped), for: .touchUpInside)
        return button
    }()

    init(presenter: InputPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Happy Birthday App"
        view.backgroundColor = .yellow
        setupViews()
        setupConstraints()
    }

    @objc private func showBirthdayButtonTapped() {
        presenter.handleShowBirthdayTap()
    }
}

private extension InputViewController {
    private func setupViews() {
        view.addSubview(nextScreenButton)
    }

    private func setupConstraints() {
        nextScreenButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            nextScreenButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextScreenButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
