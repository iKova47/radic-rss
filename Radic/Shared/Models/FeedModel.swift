//
//  FeedModel.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 25.06.2021..
//

import Foundation
import RealmSwift

final class FeedModel: Object {

    /// The url of the feed, it has to be a valid RSS feed URL.
    @objc dynamic var url: String?

    /// Optional title, if not the title of the channel will be used.
    @objc dynamic var title: String?

    /// RSS channel for the url. This property will most likely always exist.
    @objc dynamic var channel: Channel?

    override class func primaryKey() -> String? {
        "url"
    }
}
