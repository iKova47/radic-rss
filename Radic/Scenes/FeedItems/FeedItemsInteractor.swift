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
    func fetchTitle()
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
        fetchTitle()

        if let channel = viewModel.object.channel {

            worker.loadItems(for: channel)

            worker.$items.sink { [weak self] items in
                self?.presenter?.present(items: items)
            }
            .store(in: &cancellables)
        }
    }

    func fetchTitle() {

        // We will send just the title without the favIcon first
        presenter?.present(title: viewModel.title, favIcon: nil)

        // And then if the favIconURL exists, try to fetch the favicon and set the
        // new title with the new favicon
        // This is done so that we don't have a weird UX behaviour where if the
        // favIcon is unreachable, the title shows after a second or two.
        if let favIcon = viewModel.faviconURL {
            FavIconWorker.shared.fetch(from: favIcon) { image in
                self.presenter?.present(title: self.viewModel.title, favIcon: image)
            }
        }
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
