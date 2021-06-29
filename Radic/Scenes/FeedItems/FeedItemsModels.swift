//
//  FeedItemsModels.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 25.06.2021..
//


import UIKit

enum FeedItems {

    enum MarkRead {
        struct Request {
            let viewModel: FeedItemViewModel
            let index: Int
        }
    }
}
