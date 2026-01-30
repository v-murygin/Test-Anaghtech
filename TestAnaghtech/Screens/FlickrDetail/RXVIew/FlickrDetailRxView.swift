//
//  FlickrDetailRxView.swift
//  TestAnaghtech
//
//  Created by Vladislav Murygin on 1/30/26.
//

import SwiftUI

struct FlickrDetailRxView: View {
    
    let item: FlickrItem
    
    @StateObject private var viewModel: FlickrDetailRxViewModel
    
    init(item: FlickrItem, imageLoader: ImageLoaderProtocol) {
        self.item = item
        _viewModel = StateObject(wrappedValue: FlickrDetailRxViewModel(item: item, imageLoader: imageLoader))
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                rxBadge
                imageSection
                favoriteButton
                contentSection
            }
            .padding()
        }
    }
    
    private var rxBadge: some View {
        Text("RxSwift Example View")
            .asBadge()
    }
    
    @ViewBuilder
    private var imageSection: some View {
        if viewModel.isLoading {
            ProgressView()
                .frame(maxWidth: .infinity)
                .frame(height: 200)
        } else if let image = viewModel.image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    private var favoriteButton: some View {
        VStack {
            Text("UIKit Button with bridging")
                .asBadge()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            FavoriteButtonUIKit(isFavorite: viewModel.isFavorite) {
                viewModel.toggleFavorite()
            }
            .frame(height: 44)
        }
    }
    
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !item.title.isEmpty {
                Text(item.title)
                    .font(.title2.bold())
            }
            
            Text("By \(item.cleanAuthor)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

