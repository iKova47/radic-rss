//
//  AddFeedPresenter.swift
//  Radic
//
//  Created by Ivan Kovacevic on 12.07.2021..
//


import UIKit

protocol AddFeedPresentationLogic {
    func present(prefillURL: URL)
    func present(response: AddFeed.Response)
}

final class AddFeedPresenter: AddFeedPresentationLogic {
    weak var viewController: AddFeedDisplayLogic?

    func present(prefillURL: URL) {
        viewController?.display(prefillURL: prefillURL)
    }

    func present(response: AddFeed.Response) {

        switch response {
        case .success:
            viewController?.displaySuccess()
        case .alreadyAdded:
            viewController?.displayAlert(title: "Warning ⚠️", message: "Feed already added")
        case .invalidURL:
            viewController?.displayAlert(title: "Error 🌍", message: "The url value must be a valid feed URL")
        case .failure(let error):
            viewController?.displayAlert(title: "Failure ⛔️", message: "Failed to add new feed: \n\(parse(error: error))")
        }
    }

    private func parse(error: Error) -> String {

        if let error = error as? FeedParseError {
            switch error {
            case .httpError(let error):
                if let error = error as? URLError {
                    return self.parse(error: error)
                }

                return error.localizedDescription

            case .dataParseError(let parseError):
                return parse(error: parseError)
            }
        }

        return error.localizedDescription
    }

    private func parse(error: DataParseError) -> String {
        switch error {
        case .noData:
            // This case, for now, probably means that the provided feed URl is not a valid `RSS` feed
            // Probably the user tried to enter json or atom url
            // Let's make this clear to the user
            return "The feed URL must be a valid RSS feed URL"
        }
    }

    // For now we support only a handful of custom error messages
    private func parse(error: URLError) -> String {
        switch error.code {
        case .unsupportedURL:
            return "The url is not in the correct format"
        case .notConnectedToInternet:
            return "The internet connection appears to be offline"
        case .appTransportSecurityRequiresSecureConnection:
            return "The URL must be secure HTTPS URL"

        default:
            return error.localizedDescription
        }
    }
}
