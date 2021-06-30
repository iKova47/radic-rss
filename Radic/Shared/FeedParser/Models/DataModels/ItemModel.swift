//
//  ItemModel.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 25.06.2021..
//

import Foundation
import RealmSwift

/// Model specification:
/// https://validator.w3.org/feed/docs/rss2.html#hrelementsOfLtitemgt
final class ItemModel: Object {

    @objc dynamic var guid: String?
    @objc dynamic var title: String?
    @objc dynamic var link: String?
    @objc dynamic var desc: String?
    @objc dynamic var pubDate: Date?
    @objc dynamic var author: String?
    @objc dynamic var enclosure: EnclosureModel?

    let channel = LinkingObjects(fromType: ChannelModel.self, property: "items")

    /// Move this property out side of the model if enough time
    @objc dynamic var isRead = false

    /*
     Although the `guid` property is part of the RSS 2.0 specification, it's not a required element, and many feeds don't use it.

     If there's no `guid` property, we should use the `link ` as the first fallback, and if the `link` is nil, we can use some other property like `title` or `description`.

     For now, we use only the `guid`.

     */
    override class func primaryKey() -> String? {
        "guid"
    }
}
