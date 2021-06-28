//
//  FeedItemsWorker.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 25.06.2021..
//

import UIKit
import Combine

final class FeedItemsWorker {

    let repository = Repository<Channel>()

    func fetchItems(for channel: Channel) -> AnyPublisher<[Item], Never> {
        repository
            .fetchResults { [channel] newChannel in
                newChannel.link == channel.link
            }
            .map { channel -> [Item] in
                Array(channel.items)
            }
            .eraseToAnyPublisher()
    }
}
