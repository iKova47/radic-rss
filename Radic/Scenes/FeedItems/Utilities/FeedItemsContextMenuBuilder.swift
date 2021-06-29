//
//  FeedItemsContextMenuBuilder.swift
//  Radic
//
//  Created by Ivan Kovacevic on 29.06.2021..
//

import UIKit

final class FeedItemsContextMenuBuilder {

    static func build(
        viewController: FeedItemsViewController,
        viewModel: FeedItemViewModel,
        indexPath: IndexPath
    ) -> UIContextMenuConfiguration {

        let identifier = String(describing: viewModel.hashValue) as NSString

        return UIContextMenuConfiguration(identifier: identifier, previewProvider: nil) { [viewController] _ in

            let router = viewController.router
            let interactor = viewController.interactor

            var children: [UIMenuElement] = []

            let toggleReadTitle = viewModel.isRead ? "Mark unread" : "Mark read"
            let toggleRead = UIAction(
                title: toggleReadTitle,
                image: UIImage(named: "")) { [interactor] _ in
                let request = FeedItems.MarkRead.Request(viewModel: viewModel, index: indexPath.row)
                interactor?.toggleRead(request: request)
            }

            children.append(toggleRead)

            if let url = viewModel.url {
                let openHomepage = UIAction(
                    title: "Open in browser",
                    image: UIImage(systemName: "safari")) { [router, interactor] _ in
                    let request = FeedItems.MarkRead.Request(viewModel: viewModel, index: indexPath.row)
                    interactor?.markRead(request: request)
                    router?.navigate(to: url)
                }

                let share = UIAction(
                    title: "Share",
                    image: UIImage(systemName: "square.and.arrow.up")) { [viewController] _ in
                    let request = Share.Request(items: [url], viewController: viewController)
                    viewController.share(request: request)
                }

                let submenu = UIMenu(title: "", image: nil, options: .displayInline, children: [openHomepage, share])
                children.append(submenu)
            }

            return UIMenu(title: "", image: nil, children: children)
        }
    }
}
