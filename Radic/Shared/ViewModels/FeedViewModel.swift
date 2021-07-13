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
    let title: String
    let description: String?
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

    var imageURL: URL? {
        guard let urlString = object.channel?.image?.url else {
            return nil
        }

        return URL(string: urlString)
    }

    var feedURL: URL? {
        URL(string: object.url)
    }

    var numberOfUnreadItemsFormatted: String {
        let count = numberOfUnreadItems
        return count > 20 ? "20+" : String(describing: count)
    }

    init(object: FeedModel, numberOfUnreadItems: Int) {
        self.object = object

        id = object.hashValue
        title = (object.title ?? object.channel?.title) ?? "Unnamed Feed"
        description = object.channel?.desc

        self.numberOfUnreadItems = numberOfUnreadItems
    }
}
