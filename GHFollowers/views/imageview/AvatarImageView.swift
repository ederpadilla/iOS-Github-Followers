import UIKit

class AvatarImageView: UIImageView {

    let placeHolderImage = Images.placeholder

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setUp() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeHolderImage
        translatesAutoresizingMaskIntoConstraints = false
    }

    func downloadAvatarImage(avatarUrl: String) {
        NetworkManager.shared.downloadImage(from: avatarUrl) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async { self.image = image }
        }
    }
}
