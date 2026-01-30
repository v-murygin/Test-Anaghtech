//
//  SearchResultsGridView.swift
//  TestAnaghtech
//
//  Created by Vladislav Murygin on 2/12/25.
//

import SwiftUI

struct SearchResultsGridView: View {
    
    let items: [FlickrItem]
    let columns: [GridItem]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(items) { item in
                    NavigationLink(destination: UnifiedDetailView(item: item)) {
                        GridCell(item: item)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 2)
        }
    }
}
