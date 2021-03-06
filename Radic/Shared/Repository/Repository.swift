//
//  FeedRepository.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 25.06.2021..
//

import Foundation
import RealmSwift
import Combine

final class Repository<Model: Object> {

    // MARK: - Fetching
    func fetch(by filter: @escaping (Model) -> Bool) -> Model? {
        fetchResults().filter(filter).first
    }

    func fetchAll() -> [Model] {
        Array(fetchResults())
    }

    func fetchAllFrozen() -> [Model] {
        Array(fetchResults().freeze())
    }

    func fetchResults() -> Results<Model> {
        guard let realm = try? Realm() else {
            fatalError("Can't get Realm instance")
        }

        return realm.objects(Model.self)
    }

    func fetchResults(by filter: @escaping (Model) -> Bool) -> AnyPublisher<Model, Never> {
        fetchResults()
            .filter(filter)
            .first
            .publisher
            .eraseToAnyPublisher()
    }

    func observableResults() -> RealmPublishers.Value<Results<Model>> {
        fetchResults().collectionPublisher
    }

    // MARK: - Updating
    func update(handler: @escaping () -> Void) {
        let realm = try? Realm()

        try? realm?.write {
            handler()
        }
    }

    // MARK: - Adding
    func add(object: Model) {
        let realm = try? Realm()

        try? realm?.write {
            realm?.add(object, update: .all)
        }
    }

    func add(objects: [Model]) {
        let realm = try? Realm()

        try? realm?.write {
            realm?.add(objects, update: .all)
        }
    }

    // MARK: - Deleting 
    func delete(object: Model) {
        let realm = try? Realm()

        try? realm?.write {
            realm?.delete(object)
        }
    }
}
