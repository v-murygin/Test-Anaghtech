//
//  ServiceTests.swift
//  TestAnaghtechTests
//
//  Created by Vladislav Murygin on 1/30/26.
//

import XCTest
@testable import TestAnaghtech

// MARK: - Mock Network Client

final class MockNetworkClient: NetworkClient {

    var fetchDataResult: Result<Data, Error> = .success(Data())
    var fetchDataCallCount = 0

    func fetch<T: Decodable>(request: URLRequest) async throws -> T {
        let data = try await fetchData(request: request)
        return try JSONDecoder().decode(T.self, from: data)
    }

    func fetchData(request: URLRequest) async throws -> Data {
        fetchDataCallCount += 1
        return try fetchDataResult.get()
    }
}

// MARK: - URLSessionClient Tests

final class URLSessionClientTests: XCTestCase {

    func test_fetchData_withServerError_throwsServerError() async {
        // Given
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        let sut = URLSessionClient(session: session)

        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(
                url: URL(string: "https://test.com")!,
                statusCode: 500,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, Data())
        }

        // When / Then
        do {
            _ = try await sut.fetchData(request: URLRequest(url: URL(string: "https://test.com")!))
            XCTFail("Expected server error")
        } catch let error as NetworkError {
            if case .serverError(let code) = error {
                XCTAssertEqual(code, 500)
            } else {
                XCTFail("Expected serverError, got \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_fetchData_withValidResponse_returnsData() async throws {
        // Given
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        let sut = URLSessionClient(session: session)
        let expectedData = "test data".data(using: .utf8)!

        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(
                url: URL(string: "https://test.com")!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, expectedData)
        }

        // When
        let data = try await sut.fetchData(request: URLRequest(url: URL(string: "https://test.com")!))

        // Then
        XCTAssertEqual(data, expectedData)
    }
}

// MARK: - ImageLoader Tests

final class ImageLoaderTests: XCTestCase {

    func test_loadImage_withEmptyURL_throwsInvalidURLError() async {
        // Given
        let mockClient = MockNetworkClient()
        let sut = ImageLoader(transport: mockClient, cache: CacheManager())

        // When / Then
        do {
            _ = try await sut.loadImage(from: "")
            XCTFail("Expected invalidURL error")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .invalidURL)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_loadImage_withValidURL_callsTransport() async throws {
        // Given
        let mockClient = MockNetworkClient()
        let image = UIImage(systemName: "star")!
        mockClient.fetchDataResult = .success(image.pngData()!)
        let sut = ImageLoader(transport: mockClient, cache: CacheManager())

        // When
        _ = try await sut.loadImage(from: "https://example.com/image.png")

        // Then
        XCTAssertEqual(mockClient.fetchDataCallCount, 1)
    }

    func test_loadImage_withInvalidImageData_throwsError() async {
        // Given
        let mockClient = MockNetworkClient()
        mockClient.fetchDataResult = .success("not an image".data(using: .utf8)!)
        let sut = ImageLoader(transport: mockClient, cache: CacheManager())

        // When / Then
        do {
            _ = try await sut.loadImage(from: "https://example.com/image.png")
            XCTFail("Expected invalidImageData error")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .invalidImageData)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}

// MARK: - FlickrService Tests

final class FlickrServiceTests: XCTestCase {

    func test_searchPhotos_buildsCorrectURL() async throws {
        // Given
        var capturedRequest: URLRequest?
        let mockClient = MockNetworkClient()

        let json = """
        {"title": "Test", "items": []}
        """
        mockClient.fetchDataResult = .success(json.data(using: .utf8)!)

        let sut = FlickrService(transport: mockClient)

        // When
        let _: FlickrFeed = try await sut.searchPhotos(query: "nature")

        // Then
        XCTAssertEqual(mockClient.fetchDataCallCount, 1)
    }

    func test_searchPhotos_withValidResponse_returnsFeed() async throws {
        // Given
        let mockClient = MockNetworkClient()
        let json = """
        {
            "title": "Recent Uploads",
            "items": [{
                "title": "Test Photo",
                "link": "https://flickr.com/photo/1",
                "media": {"m": "https://flickr.com/img.jpg"},
                "description": "A test photo",
                "published": "2025-01-29T10:00:00Z",
                "author": "nobody@flickr.com (\\"Test User\\")"
            }]
        }
        """
        mockClient.fetchDataResult = .success(json.data(using: .utf8)!)
        let sut = FlickrService(transport: mockClient)

        // When
        let feed: FlickrFeed = try await sut.searchPhotos(query: "test")

        // Then
        XCTAssertEqual(feed.items.count, 1)
        XCTAssertEqual(feed.items.first?.title, "Test Photo")
    }
}

// MARK: - MockURLProtocol

final class MockURLProtocol: URLProtocol {

    static var requestHandler: ((URLRequest) -> (HTTPURLResponse, Data))?

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            fatalError("MockURLProtocol.requestHandler is not set")
        }

        let (response, data) = handler(request)
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: data)
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
