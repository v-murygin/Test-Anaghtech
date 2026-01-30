//
//  FavoritesManagerProtocol.swift
//  TestAnaghtech
//
//  Created by Vladislav Murygin on 1/30/26.
//

import RxSwift

protocol FavoritesManagerProtocol {
    var favoritesObservable: Observable<Set<String>> { get }
    func isFavorite(id: String) -> Bool
    func toggle(id: String)
}
