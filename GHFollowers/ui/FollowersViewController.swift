import UIKit

class FollowersViewController: UIViewController {

    enum Section { case main }

    var userName: String!
    var followers: [Follower] = []

    var collectionView: UICollectionView!

    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewController()
        setUpCollectionView()
        getFollowers(userName: self.userName)
        setUpDataSource()
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
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createThreeColumnFlowLayout())
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseId)
    }

    private func createThreeColumnFlowLayout() -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        let columnsNumber: CGFloat = 3
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth / columnsNumber

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)


        return flowLayout
    }

    private func getFollowers(userName: String) {
        NetworkManager.shared.getFollowers(for: userName, page: 1) { [weak self] result in
            guard let self = self else { return }

            switch result {

            case .success(let followers):
                self.followers = followers
                self.updateData()

            case .failure(let error):
                self.presentCustomAlertOnMainThread(title: "Bad stuff", message: error.rawValue, buttonText: "Ok")

            }
        }
    }

    private func setUpDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView,
                cellProvider: { (collectionView, indexPath, follower) -> UIKit.UICollectionViewCell? in
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseId, for: indexPath) as! FollowerCell
                    cell.setFollower(follower: follower)
                    return cell
                })
    }

    private func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
}
