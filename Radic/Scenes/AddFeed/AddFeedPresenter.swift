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
            viewController?.displayAlert(title: "Failure ⛔️", message: "Failed to add new feed \(error.localizedDescription)")
        }
    }
}
