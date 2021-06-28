//
//  FeedItemsViewController.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 25.06.2021..
//

import UIKit
import Combine

protocol FeedItemsDisplayLogic: AnyObject {
    func display(title: NSAttributedString)
    func display(viewModels: [FeedItemViewModel])
}

final class FeedItemsViewController: UITableViewController {
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
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        defer {
            interactor?.fetchData()
        }

        view.backgroundColor = .systemBackground

        configureTableView()
    }
}

// MARK: - Tableview configuration & datasource
private extension FeedItemsViewController {

    func configureTableView() {
        tableView.register(FeedItemCell.self, forCellReuseIdentifier: "FeedItemCell")
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
            #warning("Display error alert here")
            return
        }

        router?.navigate(to: url)
    }
}

//// MARK: - Context menu
//extension FeedItemsViewController {
//
//    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
//
//        guard let viewModel = datasource?.itemIdentifier(for: indexPath) else {
//            return nil
//        }
//
//        return FeedsContextMenuBuilder.build(viewController: self, viewModel: viewModel)
//    }
//}

// MARK: - FeedItemsDisplayLogic
extension FeedItemsViewController: FeedItemsDisplayLogic {

    func display(title: NSAttributedString) {

        let label = UILabel()
        label.attributedText = title
        label.sizeToFit()

        navigationItem.titleView = label
    }

    func display(viewModels: [FeedItemViewModel]) {
        apply(viewModels: viewModels)
    }
}
