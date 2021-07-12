//
//  AddFeedModels.swift
//  Radic
//
//  Created by Ivan Kovacevic on 12.07.2021..
//


import UIKit

enum AddFeed {

    struct Request {
        let title: String?
        let url: URL?
    }

    enum Response {
        case success
        case failure(Error)
        case invalidURL
        case alreadyAdded
    }
}
