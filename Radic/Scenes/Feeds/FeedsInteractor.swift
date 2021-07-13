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

        Publishers.CombineLatest(
            worker.$feeds.removeDuplicates(),
            worker.$readItems.removeDuplicates()
        )
        .sink { [weak self] feeds, readItems in
            self?.presenter?.present(feeds: feeds, readItems: readItems)
        }
        .store(in: &cancellables)
    }

    func loadData() {
        worker.startDataObserving()
        refreshFeeds()
    }

    func refreshFeeds() {
        updateWorker.updateAllSavedFeeds()

        updateWorker.progressHandler = { [weak self] progress in
            DispatchQueue.main.async {
                let response = Feeds.Refresh.Response(progress: progress)
                self?.presenter?.presentRefresh(response: response)
            }
        }
    }

    func remove(request: Feeds.Remove.Request) {
        let controller = UIAlertController(
            title: "\(Localisation.Feeds.Alert.remove) \(request.viewModel.title)",
            message: Localisation.Feeds.Alert.removeMessage,
            preferredStyle: .alert
        )

        let removeAction = UIAlertAction(title: Localisation.Feeds.Alert.remove, style: .destructive) { [weak self] _ in
            self?.worker.remove(model: request.viewModel.object)
        }

        let cancelAction = UIAlertAction(title: Localisation.Feeds.Alert.cancel, style: .cancel)

        controller.addAction(removeAction)
        controller.addAction(cancelAction)

        request.viewController.present(controller, animated: true)
    }

    func rename(request: Feeds.Rename.Request) {

        let controller = UIAlertController(
            title: "\(Localisation.Feeds.Alert.rename) “\(request.viewModel.title)”",
            message: nil,
            preferredStyle: .alert
        )

        controller.addTextField { textField in
            textField.text = request.viewModel.title
        }

        let renameAction = UIAlertAction(title: Localisation.Feeds.Alert.rename, style: .default) { [weak self] _ in
            let text = controller.textFields?.first?.text ?? ""
            self?.worker.rename(model: request.viewModel.object, title: text)
        }

        let cancelAction = UIAlertAction(title: Localisation.Feeds.Alert.cancel, style: .cancel)

        controller.addAction(renameAction)
        controller.addAction(cancelAction)

        request.viewController.present(controller, animated: true)
    }

    func markAllAsRead(request: Feeds.MarkAllItemsAsRead.Request) {
        worker.markAllAsRead(model: request.viewModel.object)
    }
}
