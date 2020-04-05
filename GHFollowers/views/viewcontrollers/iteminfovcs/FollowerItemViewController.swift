import UIKit

protocol FollowerItemViewControllerDelegate: class {
    func didTapGetFollowers(user: User)
}

class FollowerItemViewController: ItemInfoViewController {

    weak var delegate: FollowerItemViewControllerDelegate!

    init(user: User, delegate: FollowerItemViewControllerDelegate) {
        super.init(user: user)
        self.delegate = delegate
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }

    private func configureItems() {
        itemInfoViewOne.setItemInfoType(itemInfoType: .followers, withCount: user.followers)
        itemInfoViewTwo.setItemInfoType(itemInfoType: .following, withCount: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }

    override func actionButtonTapped() {
        super.actionButtonTapped()
        delegate.didTapGetFollowers(user: user)
    }
}
