import UIKit

class FollowersViewController: UIViewController {

    enum Section { case main }

    var userName: String!
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var page = 1
    var hasMoreFollowers = true

    var isSearching = false

    var collectionView: UICollectionView!

    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewController()
        setUpSearchController()
        setUpCollectionView()
        getFollowers(userName: self.userName, page: self.page)
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
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseId)
        collectionView.delegate = self
    }

    private func setUpSearchController(){
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for an username😇"
        searchController.obscuresBackgroundDuringPresentation = true
        navigationItem.searchController = searchController
    }

    private func getFollowers(userName: String, page : Int) {
        showLoadingView()
        NetworkManager.shared.getFollowers(for: userName, page: page) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            switch result {

            case .success(let followers):
                if followers.count < 100 { self.hasMoreFollowers = false }
                self.followers.append(contentsOf: followers)
                if self.followers.isEmpty{
                    let message = "This user has no followers. Be the first 🚀"
                    DispatchQueue.main.async{ self.showEmptyStateView(with: message, in: self.view) }
                    return
                }
                self.updateData(followers: self.followers)

            case .failure(let error):
                self.presentCustomAlertOnMainThread(title: "Bad stuff", message: error.rawValue, buttonText: "Ok")

            }
        }
    }

    private func setUpDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseId, for: indexPath) as! FollowerCell
            cell.setFollower(follower: follower)
            return cell
        })
    }

    private func updateData(followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
}

extension FollowersViewController : UICollectionViewDelegate{

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollowers : followers
        let follower = activeArray[indexPath.item]

        let userInfoViewController = UserInfoViewController()
        userInfoViewController.username = follower.login
        let navigationController = UINavigationController(rootViewController: userInfoViewController)
        present(navigationController, animated: true)
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height {
            guard hasMoreFollowers else { return }
            page += 1
            getFollowers(userName: userName, page: page)
        }
    }
}

extension FollowersViewController : UISearchResultsUpdating, UISearchBarDelegate {

    public func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
        isSearching = true
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateData(followers: filteredFollowers)
    }

    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        updateData(followers: followers)
        isSearching = false
    }
}
