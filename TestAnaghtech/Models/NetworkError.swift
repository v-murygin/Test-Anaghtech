//
//  NetworkError.swift
//  TestAnaghtech
//
//  Created by Vladislav Murygin on 2/12/25.
//

import Foundation

enum NetworkError: LocalizedError, Equatable {
    
    case invalidURL
    case invalidResponse
    case decodingError
    case serverError(Int)
    case unknown
    case invalidImageData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .decodingError:
            return "Error decoding data"
        case .serverError(let code):
            return "Server error: \(code)"
        case .invalidImageData:
            return "Invalid image data received"
        case .unknown:
            return "An unknown error occurred"
        }
    }
    
    var failureReason: String? {
        switch self {
        case .invalidURL:
            return "The URL provided was malformed"
        case .invalidResponse:
            return "The server returned an unexpected response"
        case .decodingError:
            return "The data format was not recognized"
        case .serverError(let code):
            return "HTTP status code: \(code)"
        case .invalidImageData:
            return "Could not create image from received data"
        case .unknown:
            return nil
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .invalidURL:
            return "Please check the URL format"
        case .invalidResponse, .serverError:
            return "Please try again later"
        case .decodingError:
            return "The API response format may have changed"
        case .invalidImageData:
            return "The image may be corrupted or in an unsupported format"
        case .unknown:
            return "Please try again"
        }
    }
}
