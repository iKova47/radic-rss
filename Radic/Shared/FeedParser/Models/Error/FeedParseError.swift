//
//  FeedParserError.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 25.06.2021..
//

import Foundation

enum FeedParseError: Error {
    case httpError(Error)
    case dataParseError(DataParseError)
}
