//
//  NetworkClientProtocol.swift
//  TestAnaghtech
//
//  Created by Vladislav Murygin on 2/12/25.
//

import Foundation
import UIKit

protocol NetworkClient {
    func fetch<T: Decodable>(request: URLRequest) async throws -> T
    func fetchData(request: URLRequest) async throws -> Data
}

