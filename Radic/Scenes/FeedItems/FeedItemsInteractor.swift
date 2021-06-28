//
//  FeedItemsInteractor.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 25.06.2021..
//

import UIKit

protocol FeedItemsBusinessLogic {
    func fetchData()

}

protocol FeedItemsDataStore {
    var viewModel: FeedViewModel { get }
}

final class FeedItemsInteractor: FeedItemsBusinessLogic, FeedItemsDataStore {
    var presenter: FeedItemsPresentationLogic?
    var worker: FeedItemsWorker?

    let viewModel: FeedViewModel

    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
    }

    func fetchData() {

        if let favIcon = viewModel.faviconURL {
            FavIconWorker.shared.fetch(from: favIcon) { image in
                self.presenter?.present(title: self.viewModel.title, favIcon: image)
            }
        }
    }
}
