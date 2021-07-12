//
//  AddFeedRouter.swift
//  Radic
//
//  Created by Ivan Kovacevic on 12.07.2021..
//


import UIKit

protocol AddFeedRoutingLogic {
    
}

protocol AddFeedDataPassing {
    
}

final class AddFeedRouter: NSObject, AddFeedRoutingLogic, AddFeedDataPassing {
    weak var viewController: AddFeedViewController?
    var dataStore: AddFeedDataStore?
    
}
