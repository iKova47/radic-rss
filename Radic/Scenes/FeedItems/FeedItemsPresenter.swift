//
//  FeedItemsPresenter.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 25.06.2021..
//


import UIKit

protocol FeedItemsPresentationLogic {
    func present(items: [ItemModel], readItems: [ReadModel])
    
}

final class FeedItemsPresenter: FeedItemsPresentationLogic {
    weak var viewController: FeedItemsDisplayLogic?

    func present(items: [ItemModel], readItems: [ReadModel]) {

        let viewModels = items.map { item in
            FeedItemViewModel(item: item, isRead: readItems.contains(where: { $0.guid == item.guid }))
        }

        viewController?.display(viewModels: viewModels)
    }
}
