import UIKit

class UserInfoViewController: UIViewController {

    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    let dateLabel = BodyLabel(textAlignment: .center)
    var itemViews : [UIView] = []

    var username: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewController()
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
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
            ])
        }

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),

            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),

            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),

            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }


    func addChildViewController(childViewController: UIViewController, containerView: UIView) {
        addChild(childViewController)
        containerView.addSubview(childViewController.view)
        childViewController.view.frame = containerView.bounds
        childViewController.didMove(toParent: self)
    }

    private func getUserInfo() {
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.addChildViewController(childViewController: UserInfoHeaderViewController(user: user), containerView: self.headerView)
                    self.addChildViewController(childViewController: RepoItemViewController(user: user), containerView: self.itemViewOne)
                    self.addChildViewController(childViewController: FollowerItemViewController(user: user), containerView: self.itemViewTwo)
                    self.dateLabel.text = "GitHub since \(user.createdAt.convertToDisplayFormat())"
                }

            case .failure(let error):
                self.presentCustomAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonText: "Ok")
            }
        }
    }
}
