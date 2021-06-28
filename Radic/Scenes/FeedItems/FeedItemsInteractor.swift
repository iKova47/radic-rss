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

        if let channel = viewModel.object.channel {
            worker
                .fetchItems(for: channel)
                .sink { [weak self] items in
                    self?.presenter?.present(items: items)
                }
                .store(in: &cancellables)
        }

        if let favIcon = viewModel.faviconURL {
            FavIconWorker.shared.fetch(from: favIcon) { image in
                self.presenter?.present(title: self.viewModel.title, favIcon: image)
            }
        }
    }
}
