//
//  FeedViewModel.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 25.06.2021..
//

import Foundation

struct FeedViewModel: Hashable {

    let id: Int
    let object: FeedModel
    let items: [Item]
    let title: String
    let numberOfUnreadItems: Int

    var homepageURL: URL? {
        /// Some feeds will (incorrectly) store the link to the RSS fed in the
        /// `link` variable, this is fix for it
        guard let link = object.channel?.link else {
            return nil
        }

        var components = URLComponents(string: link)
        components?.path = ""

        return components?.url
    }

    /// An URL of the favIcon.
    ///
    /// We assume that the webpage has the `favicon.ico` file saved at the root level of the site.
    /// This assumption is wrong!
    ///
    /// Not all websites store favIcons in the root folder, the ones who don't usually store
    /// the icon in a subfolder like `images` or similar, and have a different name than what we assume.
    ///
    /// The app doesn't try to parse the `favIcon` location from the website HTML.
    /// As a result, some of the feeds will not display the favicon.
    var faviconURL: URL? {
        homepageURL?.appendingPathComponent("favicon.ico")
    }

    var feedURL: URL? {
        guard let link = object.url else {
            return nil
        }

        return URL(string: link)
    }

    var numberOfUnreadItemsFormatted: String {
        let count = numberOfUnreadItems
        if count > 20 {
            return "20+"
        }

        return String(describing: count)
    }

    init(object: FeedModel) {
        self.object = object

        id = object.hashValue
        items = object.channel == nil ? [] : Array(object.channel!.items)
        title = (object.title ?? object.channel?.title) ?? "Unnamed Feed"

        numberOfUnreadItems = items.reduce(0) { result, item in
            result + (item.isRead ? 0 : 1)
        }
    }

//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//        hasher.combine(title)
//        hasher.combine(numberOfUnreadItems)
//    }
}