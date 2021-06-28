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

        print("registerd taks with identifier", type(of: backgroundTask).identifier)

        BGTaskScheduler
            .shared
            .register(forTaskWithIdentifier: type(of: backgroundTask).identifier, using: nil) { [backgroundTask] task in
                task.expirationHandler = {
                    task.setTaskCompleted(success: false)
                }

                backgroundTask.execute { [task] result in
                    switch result {
                    case .failure(let error):
                        print("Task execution for \(type(of: backgroundTask)) has failed with error", error)
                        task.setTaskCompleted(success: false)

                    case .success:
                        task.setTaskCompleted(success: true)
                    }
                }
            }
    }

    static func submitBackgroundTasks(for identifier: String) {

        print("submitted background task with indentifier", identifier)

        do {
            let backgroundAppRefreshTaskRequest = BGAppRefreshTaskRequest(identifier: identifier)
            
            // Fetch no earlier than 15 minutes from now
            backgroundAppRefreshTaskRequest.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
            try BGTaskScheduler.shared.submit(backgroundAppRefreshTaskRequest)
            print("Submitted task request")

        } catch {
            print("Failed to submit BGTask", error)
        }
    }
}
