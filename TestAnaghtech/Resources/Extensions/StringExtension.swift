//
//  File.swift
//  TestAnaghtech
//
//  Created by Vladislav Murygin on 1/29/26.
//


import Foundation

extension String {

    func formattedAsDisplayDate() -> String {
        guard let date = FlickrDateFormatter.apiFormatter.date(from: self) else {
            return self
        }
        return FlickrDateFormatter.displayFormatter.string(from: date)
    }
}
