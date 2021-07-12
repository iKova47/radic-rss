//
//  BackgroundTaskScheduler.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 28.06.2021..
//

import UIKit
import Combine
import BackgroundTasks

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

                    // For some reason, sometimes the task is never run to the completion.
                    // The app gets suspended after only a few seconds, and the execution gets suspended.
                    // https://developer.apple.com/forums/thread/654355
                    //
                    // Having look at apple's own example app, I can see the same problem there.
                    // Link to the their example app:
                    // https://developer.apple.com/documentation/backgroundtasks/refreshing_and_maintaining_your_app_using_background_tasks
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
