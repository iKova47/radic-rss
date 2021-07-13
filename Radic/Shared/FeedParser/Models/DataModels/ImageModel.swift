//
//  ImageModel.swift
//  Radic
//
//  Created by Ivan Kovacevic on 30.06.2021..
//

import Foundation
import RealmSwift

// Model specification:
// https://validator.w3.org/feed/docs/rss2.html#ltimagegtSubelementOfLtchannelgt
//
// We only implement the required properties of the image model
final class ImageModel: Object {
    @Persisted(primaryKey: true) var url: String?
    @Persisted var title: String?
    @Persisted var link: String?
}
