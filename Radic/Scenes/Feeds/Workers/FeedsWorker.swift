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

    @Published
    var readItems: [ReadModel] = []

    private var cancellables: Set<AnyCancellable> = []
    private let feedRepository = Repository<FeedModel>()
    private let readRepository = Repository<ReadModel>()
    private let parser = FeedParser()
}

// MARK: - DB work
extension FeedsWorker {

    func startDataObserving() {

        feedRepository
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

        readRepository
            .observableResults()
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    Log.error("Failed to fetch read items", error: error, category: .feeds)
                }
            } receiveValue: { [weak self] items in
                self?.readItems = Array(items)
            }
            .store(in: &cancellables)
    }

    func remove(model: FeedModel) {
        feedRepository.delete(object: model)
    }

    func rename(model: FeedModel, title: String) {
        feedRepository.update { [model] in
            model.title = title
        }
    }

    func markAllAsRead(model: FeedModel) {
        guard let channel = model.channel else {
            return
        }

        let items = channel.items.map { item -> ReadModel in
            let readItem = ReadModel()
            readItem.guid = item.guid
            return readItem
        }

        readRepository.add(objects: Array(items))
    }
}
