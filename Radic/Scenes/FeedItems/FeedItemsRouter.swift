//
//  FeedItemsRouter.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 25.06.2021..
//


import UIKit

protocol FeedItemsRoutingLogic {
    
}

protocol FeedItemsDataPassing {
    
}

final class FeedItemsRouter: NSObject, FeedItemsRoutingLogic, FeedItemsDataPassing {
    weak var viewController: FeedItemsViewController?
    var dataStore: FeedItemsDataStore?
    
}
