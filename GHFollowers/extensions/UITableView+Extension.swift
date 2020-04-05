import UIKit

extension UITableView {

    func reloadDataOnMainThread() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }

    func removeExtraCells() { tableFooterView = UIView(frame: .zero) }
}
