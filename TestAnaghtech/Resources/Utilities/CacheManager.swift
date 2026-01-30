//
//  CacheManager.swift
//  TestAnaghtech
//
//  Created by Vladislav Murygin on 2/13/25.
//

import SwiftUI

actor CacheManager {
    
    static let shared = CacheManager()
    
    private var cache: [String: UIImage] = [:]
    
    func insert(_ image: UIImage, for key: String) {
        cache[key] = image
    }
    
    func get(for key: String) -> UIImage? {
        cache[key]
    }
}
