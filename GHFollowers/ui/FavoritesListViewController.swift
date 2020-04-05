import UIKit

class FavoritesListViewController: UIViewController {

    let tableView = UITableView()
    var favorites: [Follower] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewController()
        setUpTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavoritesListSaved()
    }

    private func getFavoritesListSaved() {
        PersistenceManager.retrieveFavorites { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let favorites):
                if favorites.isEmpty {
                    self.showEmptyStateView(with: "No Favorites👩‍🚀?\nAdd one on the follower screen.", in: self.view)
                } else {
                    self.favorites = favorites
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.view.bringSubviewToFront(self.tableView)
                    }
                    // or
                    //self.tableView.reloadDataOnMainThread()
                    //self.view.bringSubviewToFront(self.tableView)
                }
            case .failure(let error):
                self.presentCustomAlertOnMainThread(title: "Something went wrong 🧛‍", message: error.rawValue, buttonText: "Ok")
            }
        }
    }

    private func setUpViewController() {
        view.backgroundColor = .systemBackground
        title = "Favorites 🖤"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setUpTableView() {
        view.addSubview(tableView)

        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.removeExtraCells()

        tableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: FavoriteTableViewCell.reuseId)
    }
}

extension FavoritesListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.reuseId) as! FavoriteTableViewCell
        let favorite = favorites[indexPath.row]
        cell.set(favorite: favorite)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let followerListViewController = FollowersListViewController(userName: favorite.login)
        navigationController?.pushViewController(followerListViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }

        let favorite = favorites[indexPath.row]
        favorites.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)

        PersistenceManager.updateWith(favorite: favorite, actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else { return }
            self.presentCustomAlertOnMainThread(title: "Unable to remove 😅", message: error.rawValue, buttonText: "Ok")
        }
    }
}
