//
//  AddFeedWorker.swift
//  Radic
//
//  Created by Ivan Kovacevic on 12.07.2021..
//

import UIKit
import Combine

final class AddFeedWorker {

    private enum Constants {
        static let rssURLKeywords: Set<String> = ["rss", "feed"]
    }

    private var parserCancellable: AnyCancellable?
    private let feedRepository = Repository<FeedModel>()

    // MARK: - Lifecycle
    func fetchPasteboardContent() -> URL? {
        guard let value = UIPasteboard.general.string else {
            return nil
        }

        guard let url = URL(string: value) else {
            return nil
        }

        return isProbablyRSSURL(url: url) ? url : nil
    }


    func alreadyContainsFeed(with url: URL) -> Bool {
        feedRepository.fetchAll().contains(where: { $0.url == url.absoluteString })
    }

    func addFeed(title: String?, url: URL, completionHandler: @escaping (Result<Void, Error>) -> Void) {

        parserCancellable = FeedParser()
            .parse(contentsOf: url)
            .map { channel -> FeedModel in
                FeedModel(url: url.absoluteString, title: title, channel: channel)
            }
            .sink { completion in
                switch completion {
                case .finished:
                    Log.debug("Successfully added a new feed", category: .feeds)
                case .failure(let error):
                    Log.debug("Failed to add a new feed \(error.localizedDescription)", category: .feeds)
                    completionHandler(.failure(error))
                }
            } receiveValue: { [weak self] feed in
                self?.feedRepository.add(object: feed)
                completionHandler(.success(()))
            }
    }
}

// MARK: - Private
private extension AddFeedWorker {

    /// Check if the given URL contains keyboards generally associated with an RSS feed URL.
    func isProbablyRSSURL(url: URL) -> Bool {
        url.pathComponents.contains { value in
            Constants.rssURLKeywords.contains(where: { value.contains($0) })
        }
    }
}
