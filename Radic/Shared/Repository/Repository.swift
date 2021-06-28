//
//  FeedRepository.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 25.06.2021..
//

import Foundation
import RealmSwift

final class Repository<Model: Object> {

    // MARK: - Fetching
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

    func observableResults() -> RealmPublishers.Value<Results<Model>> {
        fetchResults().collectionPublisher
    }

    // MARK: - Updating
    func update(object: Model, handler: @escaping (Model) -> Void) {
        let realm = try? Realm()

        try? realm?.write {
            handler(object)
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
