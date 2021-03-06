//
//  FeedsViewController.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 26.06.2021..
//

import UIKit
import Combine // Remove this

protocol FeedsDisplayLogic: AnyObject {
    func display(feeds: [FeedViewModel])
    func displayRefresh(progress: Float, formattedProgress: String)
}

final class FeedsViewController: UITableViewController, SharingController {
    var interactor: FeedsBusinessLogic?
    var router: (NSObjectProtocol & FeedsRoutingLogic & FeedsDataPassing)?
    
    private var datasource: UITableViewDiffableDataSource<Int, FeedViewModel>?

    private var emptyView: FeedsEmptyView?

    private let progressView: FeedUpdateProgressView = {
        let view = FeedUpdateProgressView()
        view.alpha = 0
        return view
    }()

    private var progressViewHideWorkItem: DispatchWorkItem?
    
    // This is temp, remove
    private var cancellables: Set<AnyCancellable> = []
    private let feedRepository = Repository<FeedModel>()
    
    // MARK: - Object lifecycle
    init() {
        super.init(style: .insetGrouped)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    private func setup() {
        let viewController = self
        let interactor = FeedsInteractor()
        let presenter = FeedsPresenter()
        let router = FeedsRouter()
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
            interactor?.loadData()
        }

        view.backgroundColor = Colors.backgroundColor
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = Localisation.Feeds.title
                
        configureTableView()
        addToolbar()
    }
}

// MARK: - Tableview configuration & datasource
private extension FeedsViewController {
    
    func configureTableView() {
        tableView.register(FeedCell.self, forCellReuseIdentifier: "FeedCell")
        datasource = createDatasource()
        
        addRefreshControl()
    }
    
    func addRefreshControl() {
        
        let refreshControl = UIRefreshControl()
        
        let action = UIAction { [weak self] _ in
            self?.interactor?.refreshFeeds()
            self?.tableView.refreshControl?.endRefreshing()
            self?.progressView.alpha = 1
        }
        
        refreshControl.addAction(action, for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    func createDatasource() -> UITableViewDiffableDataSource<Int, FeedViewModel> {
        let datasource = UITableViewDiffableDataSource<Int, FeedViewModel>(tableView: tableView) { tableView, indexPath, viewModel in
            let cell: FeedCell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as!
                FeedCell
            cell.configure(with: viewModel)
            return cell
        }
        
        return datasource
    }
    
    func apply(viewModels: [FeedViewModel]) {
        var snapshoot = NSDiffableDataSourceSnapshot<Int, FeedViewModel>()
        
        snapshoot.appendSections([0])
        snapshoot.appendItems(viewModels, toSection: 0)
        
        datasource?.apply(snapshoot, animatingDifferences: false)
    }
}

// MARK: - UITableViewDelegate
extension FeedsViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = datasource?.itemIdentifier(for: indexPath) else {
            return
        }

        router?.navigateToFeedItems(for: viewModel)
    }
}

// MARK: - Context menu
extension FeedsViewController {
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        guard let viewModel = datasource?.itemIdentifier(for: indexPath) else {
            return nil
        }
        
        return FeedsContextMenuBuilder.build(viewController: self, viewModel: viewModel)
    }
}

// MARK: - Toolbar & Empty view
private extension FeedsViewController {

    func addToolbar() {

        navigationController?.isToolbarHidden = false

        // Space
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        // Add
        let addAction = UIAction { [weak self] _ in
            self?.router?.navigateToAddNewFeed()
        }

        let addButton = UIBarButtonItem(systemItem: .add, primaryAction: addAction)

        // Progress view
        let progressItem = UIBarButtonItem(customView: progressView)

        toolbarItems = [progressItem, flexibleSpace, addButton]
    }

    func addEmptyView() {
        guard emptyView == nil else {
            return
        }

        let emptyView = FeedsEmptyView()
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyView)

        NSLayoutConstraint.activate([
            emptyView.widthAnchor.constraint(equalToConstant: 300),
            emptyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        self.emptyView = emptyView
    }

    func removeEmptyView() {
        guard emptyView != nil else {
            return
        }

        emptyView?.removeFromSuperview()
        emptyView = nil
    }
}

// MARK: - FeedsDisplayLogic
extension FeedsViewController: FeedsDisplayLogic {
    
    func display(feeds: [FeedViewModel]) {
        apply(viewModels: feeds)

        if feeds.isEmpty {
            addEmptyView()

        } else {
            removeEmptyView()
        }
    }

    func displayRefresh(progress: Float, formattedProgress: String) {
        progressView.set(progress: progress, formattedProgress: formattedProgress)
        progressView.alpha = 1

        if progress == 1 {
            progressViewHideWorkItem = DispatchWorkItem { [weak self] in
                self?.progressView.alpha = 0
            }

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: progressViewHideWorkItem!)

        } else if let task = progressViewHideWorkItem {
            task.cancel()
        }
    }
}
