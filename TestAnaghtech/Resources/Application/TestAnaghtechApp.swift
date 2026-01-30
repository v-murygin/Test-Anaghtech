//
//  TestAnaghtechApp.swift
//  TestAnaghtech
//
//  Created by Vladislav Murygin on 2/12/25.
//

import SwiftUI

@main
struct TestAnaghtechApp: App {
    
    private let transport = URLSessionClient()
    private let flickrService: FlickrServiceProtocol
    private let imageLoader: ImageLoaderProtocol
    
    init() {
        self.flickrService = FlickrService(transport: transport)
        self.imageLoader = ImageLoader(transport: transport, cache: .shared)
    }
    
    var body: some Scene {
        WindowGroup {
            FlickrSearchView()
                .environment(\.flickrService, flickrService)
                .environment(\.imageLoader, imageLoader)
        }
    }
}
