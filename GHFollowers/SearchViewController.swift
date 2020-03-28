import UIKit

class SearchViewController: UIViewController {

    let logoImageView = UIImageView()
    let userNameTextField = PrimaryTextField()
    let goButton = PrimaryButton(backgroundColor: .systemGreen, title: "Get Followers")

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
        navigationController?.isNavigationBarHidden = true
    }

    func dismissKeyBoard() {
        let tapOutside = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapOutside)
    }

    @objc private func pushFollowersViewController() {
        guard isInvalidUserName else {
            print("invalid username 😅")
            return
        }
        let followerListViewController = FollowersViewController()
        followerListViewController.userName = userNameTextField.text
        followerListViewController.title = userNameTextField.text
        navigationController?.pushViewController(followerListViewController, animated: true)
    }

    private func setUpLogoImageView() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "gh-logo")!

        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
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
