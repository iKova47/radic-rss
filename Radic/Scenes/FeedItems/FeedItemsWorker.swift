//
//  FeedItemsWorker.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 25.06.2021..
//

import UIKit
import Combine

final class FeedItemsWorker {

    private let channelRepository = Repository<ChannelModel>()
    private let itemRepository = Repository<ItemModel>()
    private var cancellables: Set<AnyCancellable> = []

    @Published
    var items: [ItemModel] = []

    // MARK: - Lifecycle
    func loadItems(for channel: ChannelModel) {
        self.items = Array(channel.items)
    }

    func markRead(isRead: Bool, item: ItemModel, index: Int) {
        itemRepository.update { [weak self] in
            guard let self = self else { return }

            let items = self.items
            items[index].isRead = isRead
            self.items = items
        }
    }
}
