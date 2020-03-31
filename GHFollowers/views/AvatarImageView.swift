import UIKit

class AvatarImageView: UIImageView {

    let placeHolderImage = UIImage(named: "avatar-placeholder")

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

    func downloadImage(from urlString: String){
        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) {[weak self] data, response, error in

            guard let self = self else { return }
            if error != nil { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }

            guard let data = data else { return }

            guard let image = UIImage(data: data) else { return }

            DispatchQueue.main.async {
                self.image = image
            }
        }
        task.resume()

    }
}
