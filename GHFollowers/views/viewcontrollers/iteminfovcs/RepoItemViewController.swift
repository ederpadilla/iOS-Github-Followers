import UIKit

protocol RepoItemViewControllerDelegate: class {
    func didTapGitHubProfile(user: User)
}

class RepoItemViewController: ItemInfoViewController {

    weak var delegate: RepoItemViewControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }


    private func configureItems() {
        itemInfoViewOne.setItemInfoType(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.setItemInfoType(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "GitHub Profile")
    }

    override func actionButtonTapped() {
        super.actionButtonTapped()
        delegate.didTapGitHubProfile(user: user)
    }
}
