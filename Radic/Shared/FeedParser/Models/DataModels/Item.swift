//
//  Item.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 25.06.2021..
//

import Foundation
import RealmSwift

// Main post item model
final class Item: Object {

    @objc dynamic var guid: String?
    @objc dynamic var title: String?
    @objc dynamic var link: String?
    @objc dynamic var desc: String?
    @objc dynamic var pubDate: Date?
    @objc dynamic var creator: String?
    @objc dynamic var image: String?

    let channel = LinkingObjects(fromType: Channel.self, property: "items")

    #warning("Remove these 2")
    @objc dynamic var isStarred = false
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
