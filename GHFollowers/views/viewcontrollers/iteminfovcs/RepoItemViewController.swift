import UIKit

class RepoItemViewController: ItemInfoViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }


    private func configureItems() {
        itemInfoViewOne.setItemInfoType(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.setItemInfoType(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "GitHub Profile")
    }
}
