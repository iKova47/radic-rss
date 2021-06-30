//
//  FeedItemsInteractor.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 25.06.2021..
//

import UIKit
import Combine

protocol FeedItemsBusinessLogic {
    func fetchData()
    func markRead(request: FeedItems.MarkRead.Request)
    func toggleRead(request: FeedItems.MarkRead.Request)
}

protocol FeedItemsDataStore {
    var viewModel: FeedViewModel { get }
}

final class FeedItemsInteractor: FeedItemsBusinessLogic, FeedItemsDataStore {
    var presenter: FeedItemsPresentationLogic?
    private let worker = FeedItemsWorker()
    private var cancellables: Set<AnyCancellable> = []

    let viewModel: FeedViewModel

    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
    }

    func fetchData() {
        guard let channel = viewModel.object.channel else {
            return
        }

        worker.loadItems(for: channel)

        worker.$items.sink { [weak self] items in
            self?.presenter?.present(items: items)
        }
        .store(in: &cancellables)
    }

    func markRead(request: FeedItems.MarkRead.Request) {
        guard !request.viewModel.isRead else {
            return
        }

        worker.markRead(isRead: true, item: request.viewModel.item, index: request.index)
    }

    func toggleRead(request: FeedItems.MarkRead.Request) {
        let isRead = !request.viewModel.isRead
        worker.markRead(isRead: isRead, item: request.viewModel.item, index: request.index)
    }
}
