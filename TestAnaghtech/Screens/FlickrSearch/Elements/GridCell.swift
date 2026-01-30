//
//  GridCell.swift
//  TestAnaghtech
//
//  Created by Vladislav Murygin on 1/29/26.
//

import SwiftUI

struct GridCell: View {
    
    let item: FlickrItem
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        GeometryReader { geometry in
            CachedImageView(url: item.media.m)
                .scaledToFill()
                .frame(width: geometry.size.width, height: geometry.size.width)
                .clipped()
                .contentShape(Rectangle())
        }
        .aspectRatio(1, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .accessibilityLabel(item.title.isEmpty ? "Photo" : item.title)
        .accessibilityHint("Double tap to view details. Long press for more options.")
        .contextMenu {
            contextMenu
        }
    }
    
    @ViewBuilder
    private var contextMenu: some View {
        if let url = URL(string: item.link) {
            Button {
                openURL(url)
            } label: {
                Label("Open in Browser", systemImage: "safari")
            }
            
            ShareLink(item: url) {
                Label("Share", systemImage: "square.and.arrow.up")
            }
            
            Button {
                UIPasteboard.general.string = item.link
            } label: {
                Label("Copy Link", systemImage: "doc.on.doc")
            }
        }
    }
}

