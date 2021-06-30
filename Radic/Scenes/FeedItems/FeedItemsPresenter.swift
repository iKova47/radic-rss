//
//  FeedItemsPresenter.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 25.06.2021..
//


import UIKit

protocol FeedItemsPresentationLogic {
    func present(items: [ItemModel])
    
}

final class FeedItemsPresenter: FeedItemsPresentationLogic {
    weak var viewController: FeedItemsDisplayLogic?

    func present(items: [ItemModel]) {
        let viewModels = items.map(FeedItemViewModel.init(item:))
        viewController?.display(viewModels: viewModels)
    }
}
