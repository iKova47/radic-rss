//
//  ChannelModel.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 25.06.2021..
//

import Foundation
import RealmSwift

/// Model specification:
/// https://validator.w3.org/feed/docs/rss2.html#requiredChannelElements
final class ChannelModel: Object {

    // Required elements
    @objc dynamic var title: String?
    @objc dynamic var desc: String?
    @objc dynamic var link: String?

    // Optional elements
    @objc dynamic var lastBuildDate: Date?
    @objc dynamic var image: ImageModel?
    let items = List<ItemModel>()

    let feed = LinkingObjects(fromType: FeedModel.self, property: "channel")

    /// The `link` property should be unique for each new channel, so it's probably
    /// safe to use it as a primary key.
    override class func primaryKey() -> String? {
        "link"
    }
}
