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
                    Log.error("Failed to fetch feeds", error: error, category: .feeds)
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
}
