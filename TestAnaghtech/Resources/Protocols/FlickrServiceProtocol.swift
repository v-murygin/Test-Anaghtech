//
//  FlickrServiceProtocol.swift
//  TestAnaghtech
//
//  Created by Vladislav Murygin on 1/29/26.
//


import Foundation
import UIKit

protocol FlickrServiceProtocol {
    func searchPhotos<T: Decodable>(query: String) async throws -> T
}