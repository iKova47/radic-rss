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
            viewController?.displayAlert(title: Localisation.Alert.warningTitle, message: Localisation.Error.alreadyAdded)
        case .invalidURL:
            viewController?.displayAlert(title: Localisation.Alert.errorTitle, message: Localisation.Error.invalidURL)
        case .failure(let error):
            viewController?.displayAlert(title: Localisation.Alert.failureTitle, message: Localisation.Error.failed(reason: parse(error: error)))
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
            return Localisation.Error.Reason.notValidRSSURL
        }
    }

    // For now we support only a handful of custom error messages
    private func parse(error: URLError) -> String {
        switch error.code {
        case .unsupportedURL:
            return Localisation.Error.Reason.invalidURLFormat
        case .notConnectedToInternet:
            return Localisation.Error.Reason.offline
        case .appTransportSecurityRequiresSecureConnection:
            return Localisation.Error.Reason.mustBeHTTPS

        default:
            return error.localizedDescription
        }
    }
}
