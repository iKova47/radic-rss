//
//  FeedsWorker.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 26.06.2021..
//

import UIKit
import Combine

final class FeedsWorker {

    @Published
    var feeds: [FeedModel] = []

    private var cancellables: Set<AnyCancellable> = []
    private let repository = Repository<FeedModel>()
    private let parser = FeedParser()

    private let channelRepostory = Repository<Channel>()
}

// MARK: - DB work
extension FeedsWorker {

    func startDataObserving() {

        repository
            .observableResults()
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Failed to fetch data with error", error)
                }
            } receiveValue: { [weak self] feeds in
                self?.feeds = Array(feeds)

            }
            .store(in: &cancellables)
    }

    func remove(model: FeedModel) {
        repository.delete(object: model)
    }

    func rename(model: FeedModel, title: String) {
        repository.update(object: model) { model in
            model.title = title
        }
    }

    func markAllAsRead(model: FeedModel) {
        repository.update(object: model) { model in
            model.channel?.items.forEach { $0.isRead = true }
        }
    }

    func refreshFeeds() {

        feeds.forEach { feed in
            if let urlString = feed.url, let url = URL(string: urlString) {

                parser.parse(contentsOf: url).sink { _ in

                } receiveValue: { [weak self, weak feed] channel in

                    if
                        let newLastBuildDate = channel.lastBuildDate,
                        let oldLastBuildDate = feed?.channel?.lastBuildDate {
                        print("Comparing", channel.title!)

                        print("new date", DateFormatter.short.string(from: newLastBuildDate))
                        print("old date", DateFormatter.short.string(from: oldLastBuildDate))

                        if newLastBuildDate > oldLastBuildDate {
                            print(channel.title!, "is updated")
                        }
                    }

                    self?.channelRepostory.add(object: channel)
                }
                .store(in: &cancellables)
            }
        }
    }
}

extension DateFormatter {

    static let short: DateFormatter = {
        let formater = DateFormatter()
        formater.dateFormat = "MMM dd"
        return formater
    }()
}
