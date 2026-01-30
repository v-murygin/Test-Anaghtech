//
//  FlickrSearchView.swift
//  TestAnaghtech
//
//  Created by Vladislav Murygin on 2/12/25.
//

import SwiftUI

struct FlickrSearchView: View {
    
    @Environment(\.flickrService) private var flickrService
    
    @State private var searchText = ""
    @State private var viewModel = FlickrViewModel()
    
    private let columns = [
        GridItem(.flexible(), spacing: 5),
        GridItem(.flexible(), spacing: 5),
        GridItem(.flexible(), spacing: 5)
    ]
    
    var body: some View {
        NavigationStack {
            content
                .overlay {
                    if viewModel.isLoading {
                        loadingOverlayView
                    }
                }
                .searchable(text: $searchText, prompt: "Search images")
                .navigationTitle("Flickr Search")
                .toolbar {
                    if viewModel.hasResults {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Text("\(viewModel.itemCount) photos")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .accessibilityLabel("\(viewModel.itemCount) photos loaded")
                        }
                    }
                }
                .onChange(of: searchText) { _, newValue in
                    viewModel.search(for: newValue)
                }
                .task {
                    viewModel.setup(flickrService: flickrService)
                }
        }
    }
    
    private var content: some View {
        Group {
            if let errorState = viewModel.errorState {
                errorView(for: errorState)
            } else if viewModel.hasResults {
                resultsView
            } else if !searchText.isEmpty {
                emptySearchView
            } else {
                InitialStateView { selectedTags in
                    searchText = selectedTags
                }
            }
        }
    }

    private var resultsView: some View {
        SearchResultsGridView(items: viewModel.items, columns: columns)
            .refreshable {
                await viewModel.refresh()
            }
    }
    
    private var emptySearchView: some View {
        ContentUnavailableView(
            "No Results",
            systemImage: "magnifyingglass",
            description: Text("Try searching for something else")
        )
    }
    
    @ViewBuilder
    private func errorView(for errorState: FlickrViewModel.ErrorState) -> some View {
        switch errorState {
        case .network(let message):
            ContentUnavailableView {
                Label("Connection Error", systemImage: "wifi.slash")
            } description: {
                Text(message)
            } actions: {
                Button {
                    viewModel.retry()
                } label: {
                    Label("Try Again", systemImage: "arrow.clockwise")
                }
                .buttonStyle(.bordered)
                .accessibilityHint("Double tap to retry the search")
            }
            
        case .empty:
            ContentUnavailableView(
                "No Results",
                systemImage: "photo.on.rectangle.angled",
                description: Text("No photos found for \"\(searchText)\".\nTry different keywords.")
            )
            
        case .unknown(let message):
            ContentUnavailableView {
                Label("Something Went Wrong", systemImage: "exclamationmark.triangle")
            } description: {
                Text(message)
            } actions: {
                Button("Clear Search") {
                    searchText = ""
                }
                .buttonStyle(.bordered)
            }
        }
    }
    
    private var loadingOverlayView: some View {
        ProgressView()
            .scaleEffect(1.5)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.ultraThinMaterial)
            .accessibilityLabel("Loading photos")
    }
}

#Preview {
    FlickrSearchView()
}
