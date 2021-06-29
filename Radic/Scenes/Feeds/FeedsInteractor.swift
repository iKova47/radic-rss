//
//  FeedsInteractor.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 26.06.2021..
//

import UIKit
import Combine

protocol FeedsBusinessLogic {
    func loadData()
    func refreshFeeds()

    func remove(request: Feeds.Remove.Request)
    func rename(request: Feeds.Rename.Request)
    func markAllAsRead(request: Feeds.MarkAllItemsAsRead.Request)
}

protocol FeedsDataStore {

}

final class FeedsInteractor: FeedsBusinessLogic, FeedsDataStore {
    var presenter: FeedsPresentationLogic?

    private var cancellables: Set<AnyCancellable> = []
    private let worker = FeedsWorker()
    private let updateWorker = FeedsUpdateWorker()

    init() {
        observeFeeds()
    }

    private func observeFeeds() {
        worker
            .$feeds
            .receive(on: DispatchQueue.main)
            .sink { [weak self] feeds in
                self?.presenter?.present(feeds: feeds)
            }
            .store(in: &cancellables)
    }

    func loadData() {
        worker.startDataObserving()
        updateWorker.updateAllSavedFeeds()
    }

    func refreshFeeds() {
        updateWorker.updateAllSavedFeeds()

        updateWorker.progressHandler = { [weak self] progress in
            let response = Feeds.Refresh.Response(progress: progress)
            self?.presenter?.presentRefresh(response: response)
        }
    }

    func remove(request: Feeds.Remove.Request) {
        let controller = UIAlertController(
            title: "Remove \(request.viewModel.title)",
            message: "Are you sure?",
            preferredStyle: .alert
        )

        let removeAction = UIAlertAction(title: "Remove", style: .destructive) { [weak self] _ in
            self?.worker.remove(model: request.viewModel.object)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        controller.addAction(removeAction)
        controller.addAction(cancelAction)

        request.viewController.present(controller, animated: true)
    }

    func rename(request: Feeds.Rename.Request) {

        let controller = UIAlertController(
            title: "Rename “\(request.viewModel.title)”",
            message: nil,
            preferredStyle: .alert
        )

        controller.addTextField { textField in
            textField.text = request.viewModel.title
        }

        let renameAction = UIAlertAction(title: "Rename", style: .default) { [weak self] _ in
            let text = controller.textFields?.first?.text ?? ""
            self?.worker.rename(model: request.viewModel.object, title: text)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        controller.addAction(renameAction)
        controller.addAction(cancelAction)

        request.viewController.present(controller, animated: true)
    }

    func markAllAsRead(request: Feeds.MarkAllItemsAsRead.Request) {
        worker.markAllAsRead(model: request.viewModel.object)
    }
}
