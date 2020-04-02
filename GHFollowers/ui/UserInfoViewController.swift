import UIKit

class UserInfoViewController: UIViewController {

    var username: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissViewController))
        navigationItem.rightBarButtonItem = doneButton
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }

            switch result {

            case .success(let user):
                print("user \(user)")

            case .failure(let error):
                print("Error ")
                break

            }
        }
    }

    @objc private func dismissViewController() {
        dismiss(animated: true)
    }
}
