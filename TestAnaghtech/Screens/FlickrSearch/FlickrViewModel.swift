//
//  FlickrViewModel.swift
//  TestAnaghtech
//
//  Created by Vladislav Murygin on 2/12/25.
//

import Foundation
                                                                                                                                                          
@MainActor 
@Observable
final class FlickrViewModel {
    
    enum ErrorState: Equatable {
        case network(message: String)
        case empty
        case unknown(message: String)

        var isRetryable: Bool {
            switch self {
            case .network: return true
            case .empty, .unknown: return false
            }
        }
    }
    
    private enum Constants {
        static let debounceMilliseconds: UInt64 = 500
    }
    
    private(set) var items: [FlickrItem] = []
    private(set) var isLoading = false
    private(set) var errorState: ErrorState?

    var hasResults: Bool { !items.isEmpty }
    var itemCount: Int { items.count }

    private var flickrService: FlickrServiceProtocol?
    private var currentQuery: String = ""
    private var searchTask: Task<Void, Never>?

    func setup(flickrService: FlickrServiceProtocol) {
        self.flickrService = flickrService
    }
                                                                                                                                                    
    func search(for query: String) {
        searchTask?.cancel()

        let trimmedQuery = query.trimmingCharacters(in: .whitespaces)
        currentQuery = trimmedQuery

        guard !trimmedQuery.isEmpty else {
            items = []
            errorState = nil
            return
        }

        searchTask = Task {
            await performSearch(query: trimmedQuery, debounce: true)
        }
    }

    func refresh() async {
        guard !currentQuery.isEmpty else { return }
        await performSearch(query: currentQuery, debounce: false)
    }

    func retry() {
        guard !currentQuery.isEmpty else { return }
        searchTask = Task {
            await performSearch(query: currentQuery, debounce: false)
        }
    }

    private func performSearch(query: String, debounce: Bool) async {
        guard !isLoading else { return }

        isLoading = true
        errorState = nil

        defer {
            isLoading = false
        }
        
        if debounce {
            try? await Task.sleep(for: .milliseconds(Constants.debounceMilliseconds))

            guard !Task.isCancelled else {
                return
            }
        }

        do {
            guard let feed: FlickrFeed = try await flickrService?.searchPhotos(query: query) else {
                throw NetworkError.invalidResponse
            }

            try Task.checkCancellation()

            if feed.items.isEmpty {
                items = []
                errorState = .empty
            } else {
                items = feed.items
                errorState = nil
            }
        } catch {
            handleSearchError(error)
        }
    }

    private func handleSearchError(_ error: Error) {
        switch error {
        case is CancellationError:
            return
        case let urlError as URLError where urlError.code == .cancelled:
            return
        case let urlError as URLError:
            items = []
            errorState = .network(message: urlError.localizedDescription)
        case let networkError as NetworkError:
            items = []
            errorState = .network(message: networkError.localizedDescription)
        default:
            items = []
            errorState = .unknown(message: error.localizedDescription)
        }
    }
}
