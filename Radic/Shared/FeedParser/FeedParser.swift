//
//  FeedParser.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 25.06.2021..
//

import Foundation
import Combine

///
final class FeedParser {

   private let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil

        return URLSession(configuration: config)
    }()

    /// This function will
    /// - Returns: A publisher containing the data or the error
    #warning("Extend this function so the request is wrapped inside of the NSOperation")
    func parse(contentsOf url: URL) -> AnyPublisher<Channel, FeedParseError> {
        session
            .dataTaskPublisher(for: url)
            .mapError { error -> FeedParseError in
                self.mapURLSession(error: error)
            }
            .map(\.data)
            .flatMap { data -> AnyPublisher<Channel, FeedParseError> in
                self.dataParser(for: data)
                    .parse()
                    .mapError { error -> FeedParseError in
                        .dataParseError(error)
                    }
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

// MARK: - Parser & error handling
private extension FeedParser {

    /// This function intends to select the appropriate data parser for the given data instance.
    ///
    /// NOTE: - For now, we only to do the `RSSDataParsing`, and we fail intentionally
    ///         in the case the data is not in the correct RSS format.
    ///
    ///         It's possible to extend this function with an option to check whether
    ///         the data coming in is `RSS`, `Atom`, or even `jsonFeed` format.
    func dataParser(for data: Data) -> DataParser {
        RSSDataParser(data: data)
    }

    /// Map any possible error which the `URLSession` can throw at us and map it to the
    /// `FeedParseError` instance
    func mapURLSession(error: Error) -> FeedParseError {
        .httpError(error)
    }
}
