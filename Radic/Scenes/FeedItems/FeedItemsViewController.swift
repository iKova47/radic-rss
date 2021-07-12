//
//  FeedItemsViewController.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 25.06.2021..
//

import UIKit
import Combine

protocol FeedItemsDisplayLogic: AnyObject {
    func display(viewModels: [FeedItemViewModel])
}

final class FeedItemsViewController: UITableViewController, SharingController {
    var interactor: FeedItemsBusinessLogic?
    var router: (NSObjectProtocol & FeedItemsRoutingLogic & FeedItemsDataPassing)?

    private var datasource: UITableViewDiffableDataSource<Int, FeedItemViewModel>?

    // MARK: Object lifecycle
    init(viewModel: FeedViewModel) {
        super.init(style: .insetGrouped)
        setup(viewModel: viewModel)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("We don't use storyboards here")
    }

    // MARK: Setup
    private func setup(viewModel: FeedViewModel) {
        let viewController = self
        let interactor = FeedItemsInteractor(viewModel: viewModel)
        let presenter = FeedItemsPresenter()
        let router = FeedItemsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor

        viewController.title = viewModel.title
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        defer {
            interactor?.fetchData()
        }

        view.backgroundColor = Colors.backgroundColor
        configureTableView()
    }
}

// MARK: - Tableview configuration & datasource
private extension FeedItemsViewController {

    func configureTableView() {
        tableView.register(FeedItemCell.self, forCellReuseIdentifier: "FeedItemCell")
        tableView.estimatedRowHeight = 82
        tableView.rowHeight = UITableView.automaticDimension

        datasource = createDatasource()
    }

    func createDatasource() -> UITableViewDiffableDataSource<Int, FeedItemViewModel> {
        let datasource = UITableViewDiffableDataSource<Int, FeedItemViewModel>(tableView: tableView) { tableView, indexPath, viewModel in
            let cell: FeedItemCell = tableView.dequeueReusableCell(withIdentifier: "FeedItemCell", for: indexPath) as!
                FeedItemCell
            cell.configure(with: viewModel)
            return cell
        }

        return datasource
    }

    func apply(viewModels: [FeedItemViewModel]) {
        var snapshoot = NSDiffableDataSourceSnapshot<Int, FeedItemViewModel>()

        snapshoot.appendSections([0])
        snapshoot.appendItems(viewModels, toSection: 0)

        datasource?.apply(snapshoot, animatingDifferences: false)
    }
}

// MARK: - UITableViewDelegate
extension FeedItemsViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let viewModel = datasource?.itemIdentifier(for: indexPath), let url = viewModel.url else {
            return
        }

        let request = FeedItems.MarkRead.Request(viewModel: viewModel, index: indexPath.row)

        interactor?.markRead(request: request)
        router?.navigate(to: url)
    }
}

// MARK: - Context menu
extension FeedItemsViewController {

    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

        guard let viewModel = datasource?.itemIdentifier(for: indexPath) else {
            return nil
        }

        return FeedItemsContextMenuBuilder.build(
            viewController: self,
            viewModel: viewModel,
            indexPath: indexPath
        )
    }
}

// MARK: - FeedItemsDisplayLogic
extension FeedItemsViewController: FeedItemsDisplayLogic {

    func display(viewModels: [FeedItemViewModel]) {
        apply(viewModels: viewModels)
    }
}
