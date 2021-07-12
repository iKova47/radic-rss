//
//  AddFeedViewController.swift
//  Radic
//
//  Created by Ivan Kovacevic on 12.07.2021..
//

import UIKit

protocol AddFeedDisplayLogic: AnyObject {
    func display(prefillURL: URL)
    func displayAlert(title: String, message: String)
    func displaySuccess()
}

final class AddFeedViewController: UIViewController {
    var interactor: AddFeedBusinessLogic?
    var router: (NSObjectProtocol & AddFeedRoutingLogic & AddFeedDataPassing)?

    // MARK:- Views
    private let titleTextField: UITextField = {
        let textField = InsetsTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.backgroundColor = .tertiarySystemBackground
        textField.layer.borderColor = UIColor.separator.cgColor
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 1

        textField.placeholder = "Title (optional)"
        return textField
    }()

    private let urlTextField: UITextField = {
        let textField = InsetsTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.backgroundColor = .tertiarySystemBackground
        textField.layer.borderColor = UIColor.separator.cgColor
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 1

        textField.placeholder = "Feed URL"
        return textField
    }()

    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add", for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = Colors.accentColor
        return button
    }()

    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .tertiarySystemBackground
        return button
    }()

    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()

    private let activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: Setup
    private func setup() {
        let viewController = self
        let interactor = AddFeedInteractor()
        let presenter = AddFeedPresenter()
        let router = AddFeedRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()

        view.backgroundColor = Colors.backgroundColor
        title = "Add new feed"
        interactor?.requestPrefillUrl()

        titleTextField.becomeFirstResponder()
    }

    private func tryToAddNewFeed() {
        guard interactor?.canAddNewFeed ?? false else {
            return
        }

        guard let text = urlTextField.text, !text.isEmpty else {
            return
        }

        let url = URL(string: text)
        let request = AddFeed.Request(title: titleTextField.text, url: url)
        interactor?.addFeed(request: request)

        showLoader()
    }

    func showLoader() {

    }

    func hideLoader() {

    }
}

// MARK: - UI
private extension AddFeedViewController {

    func setupSubviews() {
        view.addSubview(titleTextField)
        view.addSubview(urlTextField)
        view.addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(addButton)
        buttonsStackView.addArrangedSubview(cancelButton)
        addButtonActions()

        titleTextField.delegate = self
        urlTextField.delegate = self

        NSLayoutConstraint.activate([
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleTextField.heightAnchor.constraint(equalToConstant: 40),

            urlTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            urlTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            urlTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 8),
            urlTextField.heightAnchor.constraint(equalToConstant: 40),

            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            buttonsStackView.topAnchor.constraint(equalTo: urlTextField.bottomAnchor, constant: 16),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    func addButtonActions() {

        let addButtonHandler: UIActionHandler = { [weak self] _ in
            self?.tryToAddNewFeed()
        }

        addButton.addAction(UIAction(handler: addButtonHandler), for: .touchUpInside)

        let cancelButtonHandler: UIActionHandler = { [weak self] _ in
            self?.dismiss(animated: true)
        }

        cancelButton.addAction(UIAction(handler: cancelButtonHandler), for: .touchUpInside)
    }
}

// MARK: - AddFeedDisplayLogic
extension AddFeedViewController: AddFeedDisplayLogic {

    func display(prefillURL: URL) {
        urlTextField.text = prefillURL.absoluteString
    }

    func displayAlert(title: String, message: String) {
        hideLoader()

        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let action = UIAlertAction(title: "👍", style: .default)
        controller.addAction(action)

        present(controller, animated: true)
    }

    /// Let's keep the naming convention where the functions of `AddFeedDisplayLogic` start with `display*`
    /// Later we can add some logic to display a success message or something,
    /// but for now let's dismiss the screen
    func displaySuccess() {
        dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension AddFeedViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        switch textField {
        case titleTextField:
            urlTextField.becomeFirstResponder()

        case urlTextField:
            tryToAddNewFeed()

        default:
            break
        }

        return true
    }
}
