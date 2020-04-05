import UIKit

extension UIView {
    
    func addSubViews(views: UIView...){
        for view in views { addSubview(view) }
    }
}
