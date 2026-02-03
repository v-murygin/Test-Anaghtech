//
//  FlickrService.swift
//  TestAnaghtech
//
//  Created by Vladislav Murygin on 1/29/26.
//

import Foundation
import UIKit

final class FlickrService: FlickrServiceProtocol {
    
    private let transport: NetworkClient
    private let baseURL = "https://api.flickr.com/services/feeds/photos_public.gne"
    
    init(transport: NetworkClient = URLSessionClient()) {
        self.transport = transport
    }
    
    func searchPhotos<T: Decodable>(query: String) async throws -> T {
        guard var urlComponents = URLComponents(string: baseURL) else {
            throw NetworkError.invalidURL
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1"),
            URLQueryItem(name: "tags", value: query)
        ]
        
        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        
        let request = URLRequest(url: url)
        return try await transport.fetch(request: request)
    }
}
