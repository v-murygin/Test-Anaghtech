//
//  FlickrDateFormatter.swift
//  TestAnaghtech
//
//  Created by Vladislav Murygin on 1/29/26.
//

import Foundation

struct FlickrDateFormatter {
    
    static let apiFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()
    
    static let displayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}
