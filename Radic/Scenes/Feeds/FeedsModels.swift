//
//  FeedsModels.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 26.06.2021..
//


import UIKit

enum Feeds {

    enum Remove {
        struct Request {
            let viewController: UIViewController
            let viewModel: FeedViewModel
        }
    }

    enum Rename {
        struct Request {
            let viewController: UIViewController
            let viewModel: FeedViewModel
        }
    }

    enum MarkAllItemsAsRead {
        struct Request {
            let viewModel: FeedViewModel
        }
    }

    enum Refresh {
        struct Response {
            let progress: Float
        }
    }
}
