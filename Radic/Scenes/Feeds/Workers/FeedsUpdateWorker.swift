//
//  FeedsUpdateWorker.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 28.06.2021..
//

import Foundation
import Combine

/// The sole purpose of this worker is to update the whole RSS feed
final class FeedsUpdateWorker {

    typealias ReloadResult = (channel: Channel, isUpdated: Bool)

    private var task: AnyCancellable?
    private let feedRepository = Repository<FeedModel>()
    private let channelRepository = Repository<Channel>()

    var progressHandler: ((Float) -> Void)?

    func updateAllSavedFeeds(handler: ((Result<[FeedViewModel], FeedParseError>) -> Void)? = nil) {

        let feeds = feedRepository.fetchAllFrozen()

        guard !feeds.isEmpty else {
            handler?(.success([]))
            return
        }

        let total = Float(feeds.count)
        var count: Float = 0

        cancelPreviousUpdateTask()

        let publishers = feeds.compactMap { [weak self] feed -> AnyPublisher<ReloadResult, FeedParseError>? in
            guard let urlString = feed.url, let url = URL(string: urlString) else {
                return nil
            }

            return FeedParser()
                .parse(contentsOf: url)
                .map { [weak self, feed] channel -> ReloadResult in

                    var isUpdated = false

                    if let oldBuildDate = feed.channel?.lastBuildDate, let newBuildDate = channel.lastBuildDate {
                        isUpdated = newBuildDate > oldBuildDate
                    }

                    count += 1
                    self?.progressHandler?(count/total)

                    return (channel: channel, isUpdated: isUpdated)
                }
                .eraseToAnyPublisher()
        }

        task = Publishers.MergeMany(publishers)
            .collect()
            .sink { completion in
                switch completion {
                case .finished:
                    Log.info("Feed updating completed", category: .feeds)
                case .failure(let error):
                    Log.error("Feed updating failed", error: error, category: .feeds)
                    handler?(.failure(error))
                }
            } receiveValue: { [weak self] result in
                guard !result.isEmpty else {
                    return
                }

                let updatedChannels = result
                    .filter { $0.isUpdated }
                    .map(\.channel)

                self?.updateDb(with: updatedChannels)

                let viewModels = updatedChannels
                    .compactMap(\.feed.first)
                    .map(FeedViewModel.init(object:))

                handler?(.success(viewModels))
            }
    }

    private func updateDb(with updatedChannels: [Channel]) {
        channelRepository.add(objects: updatedChannels)
    }

    func cancelPreviousUpdateTask() {
        task?.cancel()
    }
}
