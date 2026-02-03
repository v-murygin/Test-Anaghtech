//
//  UnifiedDetailView.swift
//  TestAnaghtech
//
//  Created by Vladislav Murygin on 1/29/26.
//

import SwiftUI


struct UnifiedDetailView: View {

    @Environment(\.imageLoader) private var imageLoader

    let item: FlickrItem
    @State private var viewMode: UnifiedDetailViewMode = .rxSwift

    var body: some View {
        VStack(spacing: 16) {
            header
            content
            Spacer(minLength: 0)
        }
        .padding(.horizontal)
        .navigationTitle(item.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        Picker("Mode", selection: $viewMode) {
            ForEach(UnifiedDetailViewMode.allCases, id: \.self) { mode in
                Text(mode.rawValue)
            }
        }
        .pickerStyle(.segmented)
    }

    @ViewBuilder
    private var content: some View {
        switch viewMode {
        case .native:
            FlickrDetailView(item: item)
        case .html:
            HTMLText(html: item.description)
        case .rxSwift:
            FlickrDetailRxView(item: item, imageLoader: imageLoader)
        }
    }
}

fileprivate enum UnifiedDetailViewMode: String, CaseIterable {
    case rxSwift = "RxSwift"
    case native = "Native"
    case html = "HTML"
}
