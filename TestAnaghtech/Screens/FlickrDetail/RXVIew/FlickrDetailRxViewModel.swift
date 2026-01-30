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
