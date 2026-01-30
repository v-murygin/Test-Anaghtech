//
//  ImageLoaderProtocol.swift
//  TestAnaghtech
//
//  Created by Vladislav Murygin on 1/29/26.
//


import Foundation
import UIKit

protocol ImageLoaderProtocol {
    func loadImage(from urlString: String) async throws -> UIImage
}