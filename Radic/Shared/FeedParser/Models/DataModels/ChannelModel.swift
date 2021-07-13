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
    @Persisted var title: String?
    @Persisted var desc: String?

    /// The `link` property should be unique for each new channel, so it's probably
    /// safe to use it as a primary key.
    @Persisted(primaryKey: true) var link: String?

    // Optional elements
    @Persisted var lastBuildDate: Date?
    @Persisted var image: ImageModel?
    @Persisted var items: List<ItemModel>

    @Persisted(originProperty: "channel") var feed: LinkingObjects<FeedModel>
}
