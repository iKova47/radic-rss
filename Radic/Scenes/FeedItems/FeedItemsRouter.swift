//
//  FeedItemsRouter.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 25.06.2021..
//

import UIKit
import SafariServices

protocol FeedItemsRoutingLogic {
    func navigate(to url: URL)
}

protocol FeedItemsDataPassing { }

final class FeedItemsRouter: NSObject, FeedItemsRoutingLogic, FeedItemsDataPassing {
    weak var viewController: FeedItemsViewController?
    var dataStore: FeedItemsDataStore?

    func navigate(to url: URL) {
        let vc = SFSafariViewController(url: url)
        vc.preferredControlTintColor = Colors.accentColor
        viewController?.present(vc, animated: true)
    }
}
