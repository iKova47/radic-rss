//
//  EnclosureModel.swift
//  Radic
//
//  Created by Ivan Kovacevic on 30.06.2021..
//

import Foundation
import RealmSwift

// Model specification:
// https://validator.w3.org/feed/docs/rss2.html#ltenclosuregtSubelementOfLtitemgt
final class EnclosureModel: Object {
    @objc dynamic var url: String?
    @objc dynamic var length: Int = 0
    @objc dynamic var type: String?

    override class func primaryKey() -> String? {
        "url"
    }
}
