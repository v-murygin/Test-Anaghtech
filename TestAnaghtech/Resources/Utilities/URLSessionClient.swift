//
//  URLSessionClient.swift
//  TestAnaghtech
//
//  Created by Vladislav Murygin on 2/12/25.
//

import Foundation
import UIKit

final class URLSessionClient: NetworkClient {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared) {
        self.session = session
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.decoder = decoder
    }
    
    func fetch<T: Decodable>(request: URLRequest) async throws -> T {
        let data = try await fetchData(request: request)
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Decoding error for \(T.self): \(error)")
            throw NetworkError.decodingError
        }
    }
    
    func fetchData(request: URLRequest) async throws -> Data {
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(httpResponse.statusCode)
        }
        
        return data
    }
}
