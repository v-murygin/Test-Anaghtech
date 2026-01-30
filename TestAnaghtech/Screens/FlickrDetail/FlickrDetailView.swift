//
//  FlickrDetailView.swift
//  TestAnaghtech
//
//  Created by Vladislav Murygin on 2/12/25.
//

import SwiftUI

struct FlickrDetailView: View {
    
    let item: FlickrItem
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                header
                content
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                ShareLink(item: item.link)
            }
        }
    }
    
    private var header: some View {
        CachedImageView(url: item.media.m)
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity)
            .accessibilityLabel(item.title.isEmpty ? "Photo by \(item.cleanAuthor)" : item.title)
    }
    
    private var content: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !item.title.isEmpty {
                Text(item.title)
                    .font(.title)
                    .accessibilityAddTraits(.isHeader)
            }
            
            if !item.cleanDescription.isEmpty {
                Text(item.cleanDescription)
                    .font(.body)
            }
            
            Text("By \(item.cleanAuthor)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Text("Published: \(item.published.formattedAsDisplayDate())")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            if let size = item.imageSize {
                Text("Size: \(size.width)x\(size.height)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
