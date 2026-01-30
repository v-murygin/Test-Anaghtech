//
//  ImageLoader.swift
//  TestAnaghtech
//
//  Created by Vladislav Murygin on 1/29/26.
//

import Foundation
import UIKit

final class ImageLoader: ImageLoaderProtocol {
    
    private let transport: NetworkClient
    private let cache: CacheManager
    
    init(transport: NetworkClient = URLSessionClient(), cache: CacheManager = .shared) {
        self.transport = transport
        self.cache = cache
    }
    
    func loadImage(from urlString: String) async throws -> UIImage {
        if let cachedImage = await cache.get(for: urlString) {
            return cachedImage
        }
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let request = URLRequest(url: url)
        
        let data = try await transport.fetchData(request: request)
        
        guard let image = UIImage(data: data) else {
            throw NetworkError.invalidImageData
        }
        
        await cache.insert(image, for: urlString)
        return image
    }
}
