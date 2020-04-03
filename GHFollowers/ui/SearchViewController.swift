import UIKit

class SearchViewController: UIViewController {

    let logoImageView = UIImageView()
    let userNameTextField = PrimaryTextField()
    let goButton = PrimaryButton(backgroundColor: .systemGreen, title: "Get Followers")
    var logoImageViewTopConstraint : NSLayoutConstraint!

    var isInvalidUserName: Bool { return !userNameTextField.text!.isEmpty }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        dismissKeyBoard()
        setUpLogoImageView()
        setUpTextField()
        setUpButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        userNameTextField.text = ""
    }

    func dismissKeyBoard() {
        let tapOutside = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapOutside)
    }

    @objc private func pushFollowersViewController() {
        guard isInvalidUserName else {
            presentCustomAlertOnMainThread(title: "Empty username", message: "Please enter an user name 😅", buttonText: "Ok")
            return
        }
        userNameTextField.resignFirstResponder()

        let followerListViewController = FollowersListViewController(userName: userNameTextField.text ?? "")
        navigationController?.pushViewController(followerListViewController, animated: true)
    }

    private func setUpLogoImageView() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = Images.ghLogo

        let topConstraintConstant : CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 20 : 80

        logoImageViewTopConstraint = logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstraintConstant)
        logoImageViewTopConstraint.isActive = true

        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }

    private func setUpTextField() {
        view.addSubview(userNameTextField)
        userNameTextField.delegate = self

        NSLayoutConstraint.activate([
            userNameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            userNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            userNameTextField.heightAnchor.constraint(equalToConstant: 51)
        ])
    }

    private func setUpButton() {
        view.addSubview(goButton)

        goButton.addTarget(self, action: #selector(pushFollowersViewController), for: .touchUpInside)
        NSLayoutConstraint.activate([
            goButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            goButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            goButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            goButton.heightAnchor.constraint(equalToConstant: 51)
        ])
    }
}

extension SearchViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowersViewController()
        return true
    }
}
