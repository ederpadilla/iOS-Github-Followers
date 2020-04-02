import UIKit

class FollowerItemViewController: ItemInfoViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }

    private func configureItems() {
        itemInfoViewOne.setItemInfoType(itemInfoType: .repos, withCount: user.followers)
        itemInfoViewTwo.setItemInfoType(itemInfoType: .gists, withCount: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }

    override func actionButtonTapped() {
        super.actionButtonTapped()
        delegate.didTapGetFollowers(for: user)
    }
}
