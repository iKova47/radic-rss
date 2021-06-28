//
//  FeedsContextMenuBuilder.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 26.06.2021..
//

import UIKit

final class FeedsContextMenuBuilder {

    static func build(
        viewController: FeedsViewController,
        viewModel: FeedViewModel
    ) -> UIContextMenuConfiguration {

        let identifier = String(describing: viewModel.hashValue) as NSString

        return UIContextMenuConfiguration(identifier: identifier, previewProvider: nil) { [viewController] _ in

            let router = viewController.router
            let interactor = viewController.interactor

            var children: [UIMenuElement] = []

            if let url = viewModel.homepageURL {
                let openHomepage = UIAction(
                    title: "Open Homepage",
                    image: UIImage(systemName: "safari")) { [router] _ in
                    router?.navigate(to: url)
                }

                children.append(openHomepage)

                let share = UIAction(
                    title: "Share",
                    image: UIImage(systemName: "square.and.arrow.up")) { [viewController, interactor] _ in
                    let request = Feeds.Share.Request(url: url, viewController: viewController)
                    interactor?.share(request: request)
                }

                children.append(share)
            }

            if viewModel.numberOfUnreadItems > 0 {
                let markAllAsRead = UIAction(
                    title: "Mark all as read in “\(viewModel.title)”",
                    image: UIImage(systemName: "checkmark.square")) { [interactor] _ in
                    let request = Feeds.MarkAllItemsAsRead.Request(viewModel: viewModel)
                    interactor?.markAllAsRead(request: request)
                }

                children.append(markAllAsRead)
            }

            let rename = UIAction(
                title: "Rename",
                image: UIImage(systemName: "pencil.and.outline")) { [viewController, interactor] _ in
                let request = Feeds.Rename.Request(viewController: viewController, viewModel: viewModel)
                interactor?.rename(request: request)
            }

            let remove = UIAction(
                title: "Remove",
                image: UIImage(systemName: "trash"),
                attributes: .destructive) { [viewController, interactor] _ in
                let request = Feeds.Remove.Request(viewController: viewController, viewModel: viewModel)
                interactor?.remove(request: request)
            }

            let submenu = UIMenu(title: "", image: nil, options: .displayInline, children: [rename, remove])
            children.append(submenu)

            return UIMenu(title: "", image: nil, children: children)
        }
    }
}
