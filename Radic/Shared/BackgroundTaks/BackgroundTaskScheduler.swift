//
//  BackgroundTaskScheduler.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 28.06.2021..
//

import UIKit
import Combine
import BackgroundTasks

/*
 Command to simulate the background task:

 e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.radic.rss.backgroundAppRefreshIdentifier"]
 */

final class BackgroundTaskScheduler {

    private static let queue = DispatchQueue(label: "com.radic.backgroundTaskScheduler")

    static func register(backgroundTask: BackgroundTask) {

        let identifier = type(of: backgroundTask).identifier
        Log.info("Registered new background task with identifier: \(identifier)", category: .backgroundTask)

        BGTaskScheduler
            .shared
            .register(forTaskWithIdentifier: identifier, using: nil) { [backgroundTask] task in

                Log.info("Background task with identifier: \(identifier) started")

                // Schedule new task after this one is fired
                submitBackgroundTasks(for: identifier)

                DispatchQueue.main.async {

                    #if DEBUG
                    #warning("This is for debugging purposes only, remove the line below before the app gets submitted")
                    LocalNotificationWorker.sendNotification(title: "BGTask", message: "The background task has been started")
                    #endif

                    // For some reason, this task doesn't get allowed to execute until completion
                    // The app gets suspended after only a few seconds, and the execution gets suspended.
                    // https://developer.apple.com/forums/thread/654355
                    backgroundTask.execute {
                        task.setTaskCompleted(success: true)
                        Log.info("Background task with identifier: \(identifier) completed")
                    }
                }

                task.expirationHandler = { [backgroundTask] in
                    backgroundTask.cancel()
                    task.setTaskCompleted(success: false)
                }
            }
    }

    static func submitBackgroundTasks(for identifier: String) {

        Log.info("Submitted background task with identifier: \(identifier)", category: .backgroundTask)

        let request = BGProcessingTaskRequest(identifier: identifier)
        request.requiresNetworkConnectivity = true
        request.requiresExternalPower = false

        queue.async {
            do {
                try BGTaskScheduler.shared.submit(request)
                Log.info("Background task with identifier \(identifier) successfully submitted", category: .backgroundTask)

            } catch {
                Log.error("Failed to submit Background task with identifier \(identifier)", error: error, category: .backgroundTask)
            }
        }
    }
}
