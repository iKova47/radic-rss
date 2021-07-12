//
//  AppDelegate.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 25.06.2021..
//

import UIKit

import Combine

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        BackgroundTaskScheduler.register(backgroundTask: FeedUpdateBackgroundTask())

        // I usually hate when a random app asks for a random permission as soon as the app is launched
        // But in this case this is OK, I might refactor this in the future
        LocalNotificationWorker.requestAuthorization()

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        BackgroundTaskScheduler.submitBackgroundTasks(for: FeedUpdateBackgroundTask.identifier)
    }
}
