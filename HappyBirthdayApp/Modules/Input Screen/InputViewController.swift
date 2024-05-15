//
//  InputViewController.swift
//  HappyBirthdayApp
//
//  Created by Yehonatan Yehudai on 13/05/2024.
//

import UIKit

class InputViewController: UIViewController{
    private var presenter: InputPresenterProtocol!

    enum Const {
        static let title = "Happy Birthday..."
        static let namePlaceholder = "Baby Name"
        static let birthDatePlaceholder = "Birth Date"
        static let buttonTitle = "Show birthday screen"
    }

    // MARK: - UI Elements
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()

    private let birthdateLabel: UILabel = {
        let label = UILabel()
        label.text = Const.birthDatePlaceholder
        return label
    }()

    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Const.namePlaceholder
        textField.borderStyle = .roundedRect
        textField.delegate = self
        return textField
    }()

    private let birthdatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        return datePicker
    }()

    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView(image: .init(systemName: "face.dashed"))
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.layer.masksToBounds = true

        // Expand as possible within the constraints
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.setContentHuggingPriority(.defaultHigh, for: .vertical)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarImageTapped))
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()

    private lazy var nextScreenButton: UIButton = {
        let button = UIButton()
        button.setTitle(Const.buttonTitle, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.lightGray, for: .disabled)
        button.addTarget(self, action: #selector(showBirthdayButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Life Cycle
    init(presenter: InputPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Const.title
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        presenter.onViewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        avatarImageView.layer.cornerRadius = min(avatarImageView.bounds.width, avatarImageView.bounds.height) / 2
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextField.textDidChangeNotification, object: nameTextField)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidEndEditing), name: UITextField.textDidEndEditingNotification, object: nameTextField)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidEndEditingNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: nil)
    }

    // MARK: - Handlers
    @objc private func avatarImageTapped(gesture: UIGestureRecognizer) {
        guard let sender = gesture.view else { return }

        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            sender.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                sender.transform = .identity
            }) { _ in

            }
        })
    }

    @objc private func showBirthdayButtonTapped() {
        presenter.handleShowBirthdayTap()
    }
}

extension InputViewController: InputViewProtocol {
    func update(baby: any BabyData) {
        nameTextField.text = baby.name
        
        if let birthDate = baby.birthDate {
            birthdatePicker.date = birthDate
        }

        updateImage(image: baby.image)

        updateNextScreenButtonState()
    }
    
    func updateImage(image: UIImage?) {
        guard let image = image else { return }
        avatarImageView.image = image
    }

    func updateNextScreenButtonState() {
        let isEnabled = isNonEmpty(name: nameTextField.text ?? "")
        nextScreenButton.isEnabled = isEnabled
    }

}

extension InputViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return true }
        presenter.handleNameChanged(name: text)
        view.endEditing(true)
        return false
    }
    
    // MARK: - Observer handlers
    @objc func textDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        presenter.handleNameChanged(name: text)
    }

    @objc func textDidChange() {
        updateNextScreenButtonState()
    }
}

private extension InputViewController {
    func isNonEmpty(name: String) -> Bool {
        name.trimmingCharacters(in: .whitespaces).count > 0
    }

    func setupViews() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(nameTextField)

        let birthdateStackView = UIStackView(arrangedSubviews: [birthdateLabel, birthdatePicker])
        birthdateStackView.axis = .horizontal
        birthdateStackView.spacing = 10
        stackView.addArrangedSubview(birthdateStackView)

        stackView.addArrangedSubview(avatarImageView)
        stackView.addArrangedSubview(nextScreenButton)
    }

    func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor, multiplier: 1)
        ])
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20)
        ])
    }
}
