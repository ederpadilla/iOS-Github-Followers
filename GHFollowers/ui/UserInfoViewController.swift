import UIKit

protocol UserInfoViewControllerDelegate: class {
    func didRequestFollowers(username: String)
}

class UserInfoViewController: DataLoadingViewController {

    let scrollView = UIScrollView()
    let contentVew = UIView()

    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    let dateLabel = BodyLabel(textAlignment: .center)
    var itemViews : [UIView] = []

    var username: String = ""
    weak var delegate: UserInfoViewControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewController()
        setUpScrollView()
        layoutUI()
        getUserInfo()
    }

    private func setUpViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissViewController))
        navigationItem.rightBarButtonItem = doneButton
    }

    @objc private func dismissViewController() {
        dismiss(animated: true)
    }

    func layoutUI() {
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140

        itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]

        for itemView in  itemViews {
            contentVew.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: contentVew.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: contentVew.trailingAnchor, constant: -padding)
            ])
        }

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentVew.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 210),

            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),

            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),

            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    func addChildViewController(childViewController: UIViewController, containerView: UIView) {
        addChild(childViewController)
        containerView.addSubview(childViewController.view)
        childViewController.view.frame = containerView.bounds
        childViewController.didMove(toParent: self)
    }

    private func setUpScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentVew)
        scrollView.pinToEdges(superView: view)
        contentVew.pinToEdges(superView: scrollView)

        NSLayoutConstraint.activate([
            contentVew.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentVew.heightAnchor.constraint(equalToConstant: 600)
        ])
    }

    private func getUserInfo() {
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let user):
                DispatchQueue.main.async { self.configureUIElements(user: user) }

            case .failure(let error):
                self.presentCustomAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonText: "Ok")
            }
        }
    }

    private func configureUIElements(user: User) {
        let repoItemViewController          = RepoItemViewController(user: user, delegate: self)

        let followerItemViewController = FollowerItemViewController(user: user, delegate: self)

        self.addChildViewController(childViewController: repoItemViewController, containerView: self.itemViewOne)
        self.addChildViewController(childViewController: followerItemViewController, containerView: self.itemViewTwo)
        self.addChildViewController(childViewController: UserInfoHeaderViewController(user: user), containerView: self.headerView)
        self.dateLabel.text = "GitHub since \(user.createdAt.convertToMonthYearFormat())"
    }
}

extension UserInfoViewController: RepoItemViewControllerDelegate {
    
    
    func didTapGitHubProfile(user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            presentCustomAlertOnMainThread(title: "Invalid URL", message: "The url attached to this user is invalid. 😪", buttonText: "Ok")
            return
        }
        
        presentSafariVC(with: url)
    }
}

extension UserInfoViewController: FollowerItemViewControllerDelegate {
    
    func didTapGetFollowers(user: User) {
        guard user.followers != 0 else {
            presentCustomAlertOnMainThread(title: "No followers", message: "This user has no followers. What a shame 😞.", buttonText: "So sad")
            return
        }
        
        delegate.didRequestFollowers(username: user.login)
        dismissViewController()
    }
}
