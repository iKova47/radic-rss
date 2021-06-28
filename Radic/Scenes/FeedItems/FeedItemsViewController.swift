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
}

final class FeedItemsViewController: UITableViewController, FeedItemsDisplayLogic {
    var interactor: FeedItemsBusinessLogic?
    var router: (NSObjectProtocol & FeedItemsRoutingLogic & FeedItemsDataPassing)?

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

        view.backgroundColor = .systemBackground

        interactor?.fetchData()
    }

    func display(title: NSAttributedString) {

        let label = UILabel()
        label.attributedText = title
        label.sizeToFit()

        navigationItem.titleView = label
    }
}
