//
//  DataParser.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 25.06.2021..
//

import Foundation
import Combine

protocol DataParser {
    func parse() -> AnyPublisher<ChannelModel, DataParseError>
}
