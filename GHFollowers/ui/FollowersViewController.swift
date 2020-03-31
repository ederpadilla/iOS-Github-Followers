import UIKit

class FollowersViewController: UIViewController {

    var userName : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true

        NetworkManager.shared.getFollowers(for: userName, page: 1) { followers, errorMessage in
            guard let followers = followers else{
                self.presentCustomAlertOnMainThread(title: "Bad stuff", message: errorMessage!.rawValue, buttonText: "Ok")
                return
            }
            print("Followers count \(followers.count)  \n 🚀\(followers)")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
