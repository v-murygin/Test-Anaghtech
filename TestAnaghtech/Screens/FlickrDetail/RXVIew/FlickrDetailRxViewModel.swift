//
//  FlickrDetailRxViewModel.swift
//  TestAnaghtech
//
//  Created by Vladislav Murygin on 1/30/26.
//

import UIKit
import RxSwift
import RxRelay

final class FlickrDetailRxViewModel: ObservableObject {
    
    // NOTE: For demonstration purposes:
    // This implementation bridges modern Swift Concurrency (async/await) with RxSwift
    // to fulfill the assessment requirement. In a modern greenfield SwiftUI project,
    // the @Observable macro (or ObservableObject / @Published for older targets)
    // provides native reactive capabilities, making external reactive frameworks redundant.
    
    @Published private(set) var image: UIImage?
    @Published private(set) var isLoading = true
    @Published private(set) var isFavorite = false

    private let itemId: String
    private let disposeBag = DisposeBag()

    init(item: FlickrItem, imageLoader: ImageLoaderProtocol) {
        self.itemId = item.id
        self.isFavorite = FavoritesManager.shared.isFavorite(id: item.id)

        FavoritesManager.shared.favoritesObservable
            .map { $0.contains(item.id) }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                self?.isFavorite = value
            })
            .disposed(by: disposeBag)

        loadImage(url: item.media.m, loader: imageLoader)
    }

    func toggleFavorite() {
        FavoritesManager.shared.toggle(id: itemId)
    }

    // Bridges an async/await Task into an Observable sequence to leverage
    // declarative Rx operators (like .retry) for robust error handling.
    private func loadImage(url: String, loader: ImageLoaderProtocol) {
        Observable<UIImage>.create { observer in
            let task = Task {
                do {
                    let image = try await loader.loadImage(from: url)
                    observer.onNext(image)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }
            return Disposables.create { task.cancel() }
        }
        .retry(2)
        .observe(on: MainScheduler.instance)
        .subscribe(
            onNext: { [weak self] image in
                self?.image = image
                self?.isLoading = false
            },
            onError: { [weak self] _ in
                self?.isLoading = false
            }
        )
        .disposed(by: disposeBag)
    }
}
