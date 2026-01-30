//
//  EnvironmentValues.swift
//  TestAnaghtech
//
//  Created by Vladislav Murygin on 2/13/25.
//

import SwiftUI

// MARK: - Flickr Service Key
private struct FlickrServiceKey: EnvironmentKey {
    static let defaultValue: FlickrServiceProtocol = FlickrService()
}

// MARK: - Image Loader Key
private struct ImageLoaderKey: EnvironmentKey {
    static let defaultValue: ImageLoaderProtocol = ImageLoader(cache: .shared)
}

// MARK: - Environment Values Extension
extension EnvironmentValues {
    
    var flickrService: FlickrServiceProtocol {
        get { self[FlickrServiceKey.self] }
        set { self[FlickrServiceKey.self] = newValue }
    }
    
    var imageLoader: ImageLoaderProtocol {
        get { self[ImageLoaderKey.self] }
        set { self[ImageLoaderKey.self] = newValue }
    }
}
