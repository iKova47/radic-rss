//
//  FeedUpdateBackgroundTask.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 28.06.2021..
//

import Foundation

/// This background task is used for refreshing the feed
final class FeedUpdateBackgroundTask: BackgroundTask {

    static var identifier = "com.radic.rss.backgroundAppRefreshIdentifier"
    private let worker = FeedsUpdateWorker()

    func execute(completion: @escaping (() -> Void)) {

        worker.updateAllSavedFeeds { [weak self] result in

            switch result {
            case .success(let viewModels):
                if !viewModels.isEmpty {
                    self?.notifyUser(for: viewModels)
                }

                Log.info("Received \(viewModels.count) new feeds from background task", category: .backgroundTask)
                completion()

            case .failure(let error):
                Log.error("Feed background refresh failed with error", error: error, category: .backgroundTask)
                completion()
            }
        }
    }

    func cancel() {
        worker.task?.cancel()
    }
}

// MARK: - Notifications
extension FeedUpdateBackgroundTask {

    private func notifyUser(for updatedFeeds: [FeedViewModel]) {

        let title = "New articles available"
        let message = createFeedsUpdateMessage(for: updatedFeeds)

        LocalNotificationWorker.sendNotification(title: title, message: message)
    }

    func createFeedsUpdateMessage(for feeds: [FeedViewModel]) -> String {
        let message: String

        if feeds.count < 4 {
            let titles = feeds.map(\.title)
            let formatter = ListFormatter()
            message = "New articles available for: " + formatter.string(for: titles)!

        } else {
            let first4OrLess = feeds.prefix(4)
            message = "New articles, including: " + first4OrLess.map(\.title).joined(separator: ", ") + " & more, are now available."
        }

        return message
    }
}
