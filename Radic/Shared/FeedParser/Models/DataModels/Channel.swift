//
//  Channel.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 25.06.2021..
//

import Foundation
import RealmSwift

/// Main feed model
final class Channel: Object {

    @objc dynamic var title: String?
    @objc dynamic var desc: String?
    @objc dynamic var link: String?
    @objc dynamic var lastBuildDate: Date?
    let items = List<Item>()

    let feed = LinkingObjects(fromType: FeedModel.self, property: "channel")

    /// The `link` property should be unique for each new channel, so it's probbably
    /// safe to use it as a primary key.
    override class func primaryKey() -> String? {
        "link"
    }
}
