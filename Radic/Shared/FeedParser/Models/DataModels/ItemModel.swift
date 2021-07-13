//
//  ItemModel.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 25.06.2021..
//

import Foundation
import RealmSwift

final class ReadModel: Object {
    @Persisted(primaryKey: true) var guid: String?
}

/// Model specification:
/// https://validator.w3.org/feed/docs/rss2.html#hrelementsOfLtitemgt
final class ItemModel: Object {

    /*
     Although the `guid` property is part of the RSS 2.0 specification, it's not a required element, and many feeds don't use it.

     If there's no `guid` property, we should use the `link ` as the first fallback, and if the `link` is nil, we can use some other property like `title` or `description`.

     For now, we use only the `guid`.

     */
    @Persisted(primaryKey: true) var guid: String?

    @Persisted var title: String?
    @Persisted var link: String?
    @Persisted var desc: String?
    @Persisted var pubDate: Date?
    @Persisted var author: String?
    @Persisted var enclosure: EnclosureModel?

    @Persisted(originProperty: "items") var channel: LinkingObjects<ChannelModel>
}
