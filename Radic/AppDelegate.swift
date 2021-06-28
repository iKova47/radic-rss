//
//  AppDelegate.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 25.06.2021..
//

import UIKit
import BackgroundTasks

import Combine

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {


    var cancellables: Set<AnyCancellable> = []

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        BackgroundTaskScheduler.register(backgroundTask: FeedUpdateBackgroundTask())
        LocalNotificationWorker.requestAuthorization()

        FeedParser()
            .parse(contentsOf: URL(string: "http://ivans-mpb-2018.local:8080/example1.rss")!)
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &cancellables)


        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
