//
//  SceneDelegate.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 25.06.2021..
//

import UIKit
import BackgroundTasks

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        let feedsVC = FeedsViewController()
        let feedsNC = UINavigationController(rootViewController: feedsVC)

        let splitVC = SplitViewController()
        splitVC.viewControllers = [feedsNC, EmptyFeedViewController()]

        window = UIWindow()
        window?.windowScene = scene
        window?.makeKeyAndVisible()

        window?.rootViewController = splitVC
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        BackgroundTaskScheduler.submitBackgroundTasks(for: FeedUpdateBackgroundTask.identifier)
    }
}
