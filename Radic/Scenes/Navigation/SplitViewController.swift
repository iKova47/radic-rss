//
//  SplitViewController.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 26.06.2021..
//

import UIKit

final class SplitViewController: UISplitViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        preferredDisplayMode = UISplitViewController.DisplayMode.oneBesideSecondary
    }

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        // Collapse only if the `secondaryViewController` is the `NoSelectionViewController`
        // I think this makes the most sense from the UX perspective
        secondaryViewController is NoSelectionViewController
    }
}
