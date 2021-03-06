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
    
    typealias ReloadResult = (channel: ChannelModel, isUpdated: Bool)
    
    var task: AnyCancellable?
    private let readItemRepository = Repository<ReadModel>()
    private let feedRepository = Repository<FeedModel>()
    private let channelRepository = Repository<ChannelModel>()
    private let parser = FeedParser()
    
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
        
        let publishers = feeds
            .filter { $0.channel != nil }
            .compactMap { feed -> AnyPublisher<ReloadResult, Never>? in
                guard let url = URL(string: feed.url) else {
                    // This will probably never fail
                    return nil
                }
                
                return self.parser
                    .parse(contentsOf: url)
                    .catch { [feed] error -> AnyPublisher<ChannelModel, Never> in
                        
                        // This is safe to force unwrap, we already filtered all feeds and included only the ones where the channel is non nil
                        let channel = feed.channel!
                        
                        let title = feed.title ?? channel.title ?? "Unnamed"
                        Log.error("Failed to reload feed \(title)", error: error, category: .feeds)
                        
                        return Just(channel)
                            .eraseToAnyPublisher()
                    }
                    .map { [weak self, feed] channel -> ReloadResult in
                        
                        var isUpdated = false
                        
                        // We only update the feeds by comparing the `lastBuildDate`
                        // This will, eventually, result in a bug where the channels without the `lastBuildDate` will never get updated
                        // Maybe fix the logic later
                        if let oldBuildDate = feed.channel?.lastBuildDate, let newBuildDate = channel.lastBuildDate {
                            isUpdated = newBuildDate > oldBuildDate
                        }
                        
                        #if DEBUG
                        let title = feed.title ?? channel.title ?? "Unnamed"
                        
                        if isUpdated {
                            Log.debug("Feed UPDATED \(title)")
                            
                        } else {
                            Log.debug("Feed not updated \(title)")
                        }
                        #endif
                        
                        count += 1
                        self?.progressHandler?(count/total)
                        
                        return (channel: channel, isUpdated: isUpdated)
                    }
                    .eraseToAnyPublisher()
            }
        
        task = Publishers.MergeMany(publishers)
            .collect()
            .sink { completion in
                Log.info("Feed updating completed", category: .feeds)
                
            } receiveValue: { [weak self] result in
                guard !result.isEmpty else {
                    return
                }
                
                let updatedChannelModels = result
                    .filter { $0.isUpdated }
                    .map(\.channel)
                
                Log.info("Feed update completed, \(updatedChannelModels.count) items are updated", category: .feeds)
                
                self?.updateDb(with: updatedChannelModels)
                
                let viewModels = updatedChannelModels
                    .compactMap(\.feed.first)
                    .map { FeedViewModel(object: $0, numberOfUnreadItems: 0) } // We don't care for the `numberOfUnreadItems` here since it's not used directly

                handler?(.success(viewModels))
            }
    }
    
    private func updateDb(with updatedChannelModels: [ChannelModel]) {
        channelRepository.add(objects: updatedChannelModels)
    }
    
    func cancelPreviousUpdateTask() {
        task?.cancel()
    }
}
