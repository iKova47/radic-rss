//
//  FeedsRouter.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 26.06.2021..
//


import UIKit
import SafariServices

protocol FeedsRoutingLogic {
    func navigateToAddNewFeed()
    func navigateToFeedItems(for viewModel: FeedViewModel)
    func navigate(to url: URL)
}

protocol FeedsDataPassing { }

final class FeedsRouter: NSObject, FeedsRoutingLogic, FeedsDataPassing {
    weak var viewController: FeedsViewController?
    var dataStore: FeedsDataStore?

    func navigateToAddNewFeed() {
        
    }

    func navigate(to url: URL) {
        let vc = SFSafariViewController(url: url)
        viewController?.present(vc, animated: true)
    }

    func navigateToFeedItems(for viewModel: FeedViewModel) {
        let vc = FeedItemsViewController(viewModel: viewModel)
        let nc = UINavigationController(rootViewController: vc)
        viewController?.showDetailViewController(nc, sender: nil)
    }
}
