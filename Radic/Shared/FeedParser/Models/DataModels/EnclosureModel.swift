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

    // The specification says that the all 3 variables are required
    @Persisted(primaryKey: true) var url: String = ""
    @Persisted var length: Int = 0
    @Persisted var type: String = ""
}
