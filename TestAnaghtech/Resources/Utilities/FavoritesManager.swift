//
//  FavoritesManager.swift
//  TestAnaghtech
//
//  Created by Vladislav Murygin on 1/30/26.
//

import RxSwift
import RxRelay

final class FavoritesManager: FavoritesManagerProtocol {
    
    //  Note: This is a demo implementation using in-memory storage.
    //  In production, favorites should be persisted via CoreData/SwiftData
    //  or synced with a backend API.

    static let shared = FavoritesManager()

    private let favoritesRelay = BehaviorRelay<Set<String>>(value: [])

    var favoritesObservable: Observable<Set<String>> {
        favoritesRelay.asObservable()
    }

    func isFavorite(id: String) -> Bool {
        favoritesRelay.value.contains(id)
    }

    func toggle(id: String) {
        var current = favoritesRelay.value
        if current.contains(id) {
            current.remove(id)
        } else {
            current.insert(id)
        }
        favoritesRelay.accept(current)
    }

    private init() {}
}
