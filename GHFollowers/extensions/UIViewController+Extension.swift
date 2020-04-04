import UIKit
import SafariServices

extension UIViewController {

    func presentCustomAlertOnMainThread(title: String, message: String, buttonText: String) {
        DispatchQueue.main.async {
            let customAlert = CustomAlertViewController(title: title, message: message, buttonText: buttonText)
            customAlert.modalPresentationStyle = .overFullScreen
            customAlert.modalTransitionStyle = .crossDissolve
            self.present(customAlert, animated: true)
        }
    }

    func showEmptyStateView(with message: String, in view : UIView){
        let emptyStateView = EmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }

    func presentSafariVC(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }
}
