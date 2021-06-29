//
//  SharingController.swift
//  Radic
//
//  Created by Ivan Kovacevic on 29.06.2021..
//

import UIKit

enum Share {
    struct Request {
        let items: [Any]
        let viewController: UIViewController
    }
}

/// Conform any class to enable sharing from that object instance 
protocol SharingController {
    func share(request: Share.Request)
}

extension SharingController {

    func share(request: Share.Request) {
        let controller = UIActivityViewController(activityItems: request.items, applicationActivities: nil)
        request.viewController.present(controller, animated: true)
    }
}
