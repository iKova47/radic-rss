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

final class FeedsViewController: UITableViewController {
    var interactor: FeedsBusinessLogic?
    var router: (NSObjectProtocol & FeedsRoutingLogic & FeedsDataPassing)?
    
    private var datasource: UITableViewDiffableDataSource<Int, FeedViewModel>?

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
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Feeds"
        
        view.backgroundColor = .systemGroupedBackground
        
        configureTableView()
        addToolbar()
    }
    
    @objc
    func refresh() {
        
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

// MARK: - Toolbar
private extension FeedsViewController {

    func addToolbar() {

        navigationController?.isToolbarHidden = false

        // Space
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        // Add
        let addAction = UIAction { [weak self] _ in
            self?.addNewFeed()
        }

        let addButton = UIBarButtonItem(systemItem: .add, primaryAction: addAction)

        // Progress view
        let progressItem = UIBarButtonItem(customView: progressView)

        toolbarItems = [progressItem, flexibleSpace, addButton]
    }
    
    func addAddFeedButton() {
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        
        let action = UIAction { [weak self] _ in
            //            self?.router?.navigateToAddNewFeed()
            self?.addNewFeed()
        }
        
        button.addAction(action, for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        
        navigationItem.rightBarButtonItem = barButton
    }
}

// MARK: - FeedsDisplayLogic
extension FeedsViewController: FeedsDisplayLogic {
    
    func display(feeds: [FeedViewModel]) {
        apply(viewModels: feeds)
    }

    func displayRefresh(progress: Float, formattedProgress: String) {
        progressView.set(progress: progress, formattedProgress: formattedProgress)

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

// MARK: - TEMP
private extension FeedsViewController {
    
    // This is temp
    func addNewFeed() {
        
        addNewFeed(url: "https://swiftbysundell.com/rss", title: nil)
        addNewFeed(url: "https://www.hackingwithswift.com/articles/rss", title: nil)
        addNewFeed(url: "https://ericasadun.com/feed", title: nil)
        addNewFeed(url: "https://rosemaryorchard.com/blog/feed/", title: nil)
        addNewFeed(url: "http://ivans-mpb-2018.local:8080/example1.rss", title: nil)
    }
    
    func addNewFeed(url urlString: String, title: String?) {
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        FeedParser()
            .parse(contentsOf: url)
            .map { channel -> FeedModel in
                let object = FeedModel()
                object.title = title
                object.url = urlString
                object.channel = channel
                
                return object
            }
            .sink { completion in
                switch completion {
                case .finished:
                    print("Finished adding new feed")
                case .failure(let error):
                    print("Failed to add new feed", error)
                }
            } receiveValue: { [weak self] feed in
                self?.feedRepository.add(object: feed)
            }
            .store(in: &cancellables)
    }


}
