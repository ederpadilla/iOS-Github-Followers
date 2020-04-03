import UIKit

class FavoriteTableViewCell: UITableViewCell {

    static let reuseId = "FavoriteTableViewCell"

    let avatarImageView = AvatarImageView(frame: .zero)
    let userNameLabel = PrimaryTitleLabel(textAlignment: .left, fontSize: 26)

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func set(favorite: Follower) {
        userNameLabel.text = favorite.login
        avatarImageView.downloadImage(from: favorite.avatarUrl)
    }

    private func setUp() {
        addSubview(avatarImageView)
        addSubview(userNameLabel)

        accessoryType = .disclosureIndicator
        let padding: CGFloat = 12

        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),

            userNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
            userNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            userNameLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

}
