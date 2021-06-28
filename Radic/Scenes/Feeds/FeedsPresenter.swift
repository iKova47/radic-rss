//
//  FeedsPresenter.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 26.06.2021..
//


import UIKit

protocol FeedsPresentationLogic {
    func present(feeds: [FeedModel])
    func presentRefresh(response: Feeds.Refresh.Response)
}

final class FeedsPresenter: FeedsPresentationLogic {

    weak var viewController: FeedsDisplayLogic?
    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        return formatter
    }()

    func present(feeds: [FeedModel]) {
        let viewModels = feeds.map(FeedViewModel.init)
        viewController?.display(feeds: viewModels)
    }

    func presentRefresh(response: Feeds.Refresh.Response) {
        let formatted = formatter.string(from: response.progress as NSNumber) ?? "0"
        viewController?.displayRefresh(progress: response.progress, formattedProgress: formatted)
    }
}
