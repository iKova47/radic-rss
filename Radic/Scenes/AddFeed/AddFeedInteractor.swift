//
//  AddFeedInteractor.swift
//  Radic
//
//  Created by Ivan Kovacevic on 12.07.2021..
//

import UIKit

protocol AddFeedBusinessLogic {
    var canAddNewFeed: Bool { get }

    func requestPrefillUrl()
    func addFeed(request: AddFeed.Request)

}

protocol AddFeedDataStore {
    var url: URL? { get set }
    var title: String? { get set }

}

final class AddFeedInteractor: AddFeedBusinessLogic, AddFeedDataStore {
    var presenter: AddFeedPresentationLogic?
    private let worker = AddFeedWorker()

    var canAddNewFeed = true
    var url: URL?
    var title: String?

    func requestPrefillUrl() {
        guard let url = worker.fetchPasteboardContent() else {
            return
        }

        self.url = url
        presenter?.present(prefillURL: url)
    }

    func addFeed(request: AddFeed.Request) {

        guard let url = request.url else {
            presenter?.present(response: .invalidURL)
            return
        }

        guard !worker.alreadyContainsFeed(with: url) else {
            presenter?.present(response: .alreadyAdded)
            return
        }

        let title = (request.title?.isEmpty ?? true) ? nil : request.title

        canAddNewFeed = false

        worker.addFeed(
            title: title?.trimmingCharacters(in: .whitespacesAndNewlines),
            url: url
        ) { [weak self] result in
            switch result {
            case .success:
                self?.presenter?.present(response: .success)

            case .failure(let error):
                self?.presenter?.present(response: .failure(error))
            }

            self?.canAddNewFeed = true
        }
    }
}
