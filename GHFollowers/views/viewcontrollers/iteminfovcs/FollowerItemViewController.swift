import UIKit

class FollowerItemViewController: ItemInfoViewController {

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
