//
//  InitialStateView.swift
//  TestAnaghtech
//
//  Created by Vladislav Murygin on 2/12/25.
//

import SwiftUI

struct InitialStateView: View {
    
    let onTagSelect: (String) -> Void
    
    private let suggestions = [
        "Nature", "Sunset", "City", "Night",
        "Ocean", "Beach", "Animals", "Wildlife",
        "Mountains", "Forest", "Travel", "Food",
        "Architecture", "Portrait", "Sport"
    ]
    
    var body: some View {
        ContentUnavailableView {
            Label("Start Your Search", systemImage: "photo.on.rectangle.angled")
                .symbolEffect(.bounce)
        } description: {
            Text("Enter keywords to discover amazing photos")
        } actions: {
            contentUnavailableView
        }
    }
    
    private var contentUnavailableView: some View {
        VStack(spacing: 20) {
            Text("Popular categories:")
                .foregroundStyle(.secondary)
            
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3),
                alignment: .center,
                spacing: 12
            ) {
                ForEach(suggestions, id: \.self) { tag in
                    Button {
                        onTagSelect(tag)
                    } label: {
                        Text(tag)
                            .font(.footnote)
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, minHeight: 32)
                            .background(.gray.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)
                    .frame(width: 100)
                    .accessibilityLabel("Search for \(tag)")
                    .accessibilityHint("Double tap to search photos tagged \(tag)")
                }
            }
            .accessibilityLabel("Popular search categories")
        }
    }
}

#Preview {
    InitialStateView { _ in }
}
