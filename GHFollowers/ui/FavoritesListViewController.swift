import UIKit

class FavoritesListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        getFavoritesListSaved()
    }

    private func getFavoritesListSaved() {
        PersistenceManager.retrieveFavorites { result in
            switch result {
            case .success(let favorites):
                print("favorites 🔥 \(favorites)")
                break
            case .failure(let error):
                break
            }
        }
    }
}
