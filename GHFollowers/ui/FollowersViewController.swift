import UIKit

class FollowersViewController: UIViewController {

    var userName : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true

        NetworkManager.shared.getFollowers(for: userName, page: 1) { folowers, errorMessage in
            guard let followers = folowers else{
                self.presentCustomAlertOnMainThread(title: "Bad stuff", message: errorMessage!, buttonText: "Ok")
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
