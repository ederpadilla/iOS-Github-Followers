import UIKit

extension UIViewController {

    func presentCustomAlertOnMainThread(title: String, message: String, buttonText: String) {
        DispatchQueue.main.async {
            let customAlert = CustomAlertViewController(title: title, message: message, buttonText: buttonText)
            customAlert.modalPresentationStyle = .overFullScreen
            customAlert.modalTransitionStyle = .crossDissolve
            self.present(customAlert, animated: true)
        }
    }
}
