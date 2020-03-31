import UIKit

class FollowersViewController: UIViewController {

    var userName: String!

    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewController()
        setUpCollectionView()
        getFollowers(userName: self.userName)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    private func setUpViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setUpCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemPink
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseId)
    }

    private func getFollowers(userName: String) {
        NetworkManager.shared.getFollowers(for: userName, page: 1) { result in
            switch result {

            case .success(let followers):
                print("Followers count \(followers.count)  \n 🚀\(followers)")

            case .failure(let error):
                self.presentCustomAlertOnMainThread(title: "Bad stuff", message: error.rawValue, buttonText: "Ok")

            }
        }
    }
}
