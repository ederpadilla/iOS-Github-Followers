//
//  SceneDelegate.swift
//  GHFollowers
//
//  Created by Eder  Padilla on 24/03/20.
//  Copyright © 2020 EderPadilla. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = createTabBarController()
        window?.makeKeyAndVisible()
    }

    func createSearchNavigationController() -> UINavigationController {
        let searchViewController = SearchViewController()
        searchViewController.title = "Search"
        searchViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)

        return UINavigationController(rootViewController: searchViewController)
    }

    func createFavoritesListViewController() -> UINavigationController {
        let favoritesNavController = FavoritesListViewController()
        favoritesNavController.title = "Favorites"
        favoritesNavController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)

        return UINavigationController(rootViewController: favoritesNavController)
    }

    func createTabBarController() -> UITabBarController {
        let tabBar = UITabBarController()
        UITabBar.appearance().tintColor = .systemGreen
        tabBar.viewControllers = [createSearchNavigationController(), createFavoritesListViewController()]

        return tabBar
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}

