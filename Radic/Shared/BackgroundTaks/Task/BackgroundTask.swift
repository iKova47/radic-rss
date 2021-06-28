//
//  BackgroundTask.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 28.06.2021..
//

import Foundation

protocol BackgroundTask {
    static var identifier: String { get }
    func execute(completion: @escaping (Result<Void, Error>) -> Void)
}
