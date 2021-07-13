//
//  FeedsPresenter.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 26.06.2021..
//


import UIKit

protocol FeedsPresentationLogic {
    func present(feeds: [FeedModel], readItems: [ReadModel])
    func presentRefresh(response: Feeds.Refresh.Response)
}

final class FeedsPresenter: FeedsPresentationLogic {

    weak var viewController: FeedsDisplayLogic?
    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        return formatter
    }()

    func present(feeds: [FeedModel], readItems: [ReadModel]) {
        let viewModels = feeds.compactMap { feed -> FeedViewModel? in
            guard let channel = feed.channel else {
                return nil
            }

            let allChannelItems = channel.items
            let readItems = readItems.filter { readItem in
                allChannelItems.contains(where: { $0.guid == readItem.guid })
            }

            let unreadCount = allChannelItems.count - readItems.count

            return FeedViewModel(object: feed, numberOfUnreadItems: unreadCount)
        }

        viewController?.display(feeds: viewModels)
    }

    func presentRefresh(response: Feeds.Refresh.Response) {
        let formatted = formatter.string(from: response.progress as NSNumber) ?? "0"
        viewController?.displayRefresh(progress: response.progress, formattedProgress: formatted)
    }
}
