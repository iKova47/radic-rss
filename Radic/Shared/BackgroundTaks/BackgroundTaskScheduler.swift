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
 To simulate the background task from Xcode, use this command in the Xcode console:

 e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.radic.rss.backgroundAppRefreshIdentifier"]
 */

final class BackgroundTaskScheduler {

    static func register(backgroundTask: BackgroundTask) {

        let identifier = type(of: backgroundTask).identifier
        Log.info("Registered new background task with identifier: \(identifier)", category: .backgroundTask)

        BGTaskScheduler
            .shared
            .register(forTaskWithIdentifier: identifier, using: nil) { [backgroundTask] task in
                task.expirationHandler = {
                    task.setTaskCompleted(success: false)
                }

                backgroundTask.execute { [task] result in
                    switch result {
                    case .failure(let error):
                        Log.error("Task execution for \(type(of: backgroundTask)) has failed with error", error: error, category: .backgroundTask)
                        task.setTaskCompleted(success: false)

                    case .success:
                        task.setTaskCompleted(success: true)
                    }
                }
            }
    }

    static func submitBackgroundTasks(for identifier: String) {

        Log.info("Submitted background task with identifier: \(identifier)", category: .backgroundTask)

        BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: identifier)

        do {
            let backgroundAppRefreshTaskRequest = BGAppRefreshTaskRequest(identifier: identifier)
            
            // Fetch no earlier than 15 minutes from now
            backgroundAppRefreshTaskRequest.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)

            try BGTaskScheduler.shared.submit(backgroundAppRefreshTaskRequest)
            Log.info("Task with identifier \(identifier) successfully submitted", category: .backgroundTask)

        } catch {
            Log.error("Failed to submit task with identifier \(identifier)", error: error, category: .backgroundTask)
        }
    }
}
