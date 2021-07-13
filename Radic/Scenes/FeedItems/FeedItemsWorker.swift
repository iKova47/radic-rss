//
//  FeedItemsWorker.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 25.06.2021..
//

import UIKit
import Combine

final class FeedItemsWorker {

    private let readItemRepository = Repository<ReadModel>()
    private let channelRepository = Repository<ChannelModel>()
    private let itemRepository = Repository<ItemModel>()
    private var cancellables: Set<AnyCancellable> = []

    @Published
    var items: [ItemModel] = []

    @Published
    var readItems: [ReadModel] = []

    // MARK: - Lifecycle
    func loadItems(for channel: ChannelModel) {
        self.items = Array(channel.items)

        readItemRepository
            .observableResults()
            .sink { _ in
                // Don't care about this

        } receiveValue: { [weak self] items in
            self?.readItems = Array(items)
        }
        .store(in: &cancellables)
    }

    func markRead(isRead: Bool, item: ItemModel, index: Int) {
        if isRead {
            let readItem = ReadModel()
            readItem.guid = item.guid
            readItemRepository.add(object: readItem)

        } else {
            if let readItem = readItemRepository.fetch(by: { $0.guid == item.guid }) {
                readItemRepository.delete(object: readItem)
            }
        }
    }
}
