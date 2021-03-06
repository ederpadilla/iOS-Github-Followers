import UIKit

class CustomAlertViewController: UIViewController {

    let containerViewController = CustomAlertContainerView()
    let titleLabel = PrimaryTitleLabel(textAlignment: .center, fontSize: 20)
    let messageLabel = BodyLabel(textAlignment: .center)
    let acceptButton = PrimaryButton(backgroundColor: .systemPink, title: "Ok")

    var alertTitle: String?
    var message: String?
    var buttonText: String?

    let padding: CGFloat = 20

    init(title: String, message: String, buttonText: String) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = title
        self.message = message
        self.buttonText = buttonText
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        view.addSubViews(views: containerViewController, titleLabel, messageLabel, acceptButton)
        setUpContainerView()
        setUpTitle()
        setUpMessage()
        setUpButton()
    }

    private func setUpContainerView() {

        NSLayoutConstraint.activate([
            containerViewController.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerViewController.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerViewController.widthAnchor.constraint(equalToConstant: 280),
            containerViewController.heightAnchor.constraint(equalToConstant: 220)
        ])
    }

    private func setUpTitle() {
        titleLabel.text = alertTitle ?? "nil"
        messageLabel.text = message ?? "nil"

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerViewController.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerViewController.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerViewController.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }

    private func setUpMessage() {
        messageLabel.text = message ?? "nil"
        messageLabel.numberOfLines = 4

        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: containerViewController.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: containerViewController.trailingAnchor, constant: -padding),
            messageLabel.bottomAnchor.constraint(equalTo: acceptButton.topAnchor, constant: -12)
        ])
    }

    private func setUpButton() {
        acceptButton.setTitle(buttonText, for: .normal)
        acceptButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)

        NSLayoutConstraint.activate([
            acceptButton.bottomAnchor.constraint(equalTo: containerViewController.bottomAnchor, constant: -padding),
            acceptButton.leadingAnchor.constraint(equalTo: containerViewController.leadingAnchor, constant: padding),
            acceptButton.trailingAnchor.constraint(equalTo: containerViewController.trailingAnchor, constant: -padding),
            acceptButton.heightAnchor.constraint(equalToConstant: 51)
        ])
    }

    @objc private func dismissViewController() { dismiss(animated: true) }
}
