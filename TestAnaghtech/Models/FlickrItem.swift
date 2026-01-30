//
//  FlickrItem.swift
//  TestAnaghtech
//
//  Created by Vladislav Murygin on 2/12/25.
//

import Foundation

struct FlickrItem: Codable, Identifiable, Equatable {
    
    let title: String
    let link: String
    let media: Media
    let description: String
    let published: String
    let author: String
    
    var id: String { link }
    
    struct Media: Codable, Equatable {
        let m: String
        
        enum CodingKeys: String, CodingKey {
            case m = "m"
        }
    }
    
   
    var cleanDescription: String {
        guard let regex = try? NSRegularExpression(pattern: "<[^>]+>") else {
            return description
        }
        
        let range = NSRange(description.startIndex..., in: description)
        let cleanText = regex.stringByReplacingMatches(
            in: description,
            range: range,
            withTemplate: ""
        )

        return cleanText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "&quot;", with: "\"")
            .replacingOccurrences(of: "&amp;", with: "&")
            .replacingOccurrences(of: "&lt;", with: "<")
            .replacingOccurrences(of: "&gt;", with: ">")
    }
    
  
    var cleanAuthor: String {
        let pattern = "nobody@flickr.com \\(\"(.+)\"\\)"
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: author, range: NSRange(author.startIndex..., in: author)),
              let range = Range(match.range(at: 1), in: author) else {
            return author
        }
        return String(author[range])
    }
    
    var imageSize: (width: Int, height: Int)? {
        let pattern = #"width="(\d+)" height="(\d+)""#
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: description,
                                         range: NSRange(description.startIndex..., in: description)) else {
            return nil
        }
        
        guard let widthRange = Range(match.range(at: 1), in: description),
              let heightRange = Range(match.range(at: 2), in: description),
              let width = Int(description[widthRange]),
              let height = Int(description[heightRange]) else {
            return nil
        }
        
        return (width, height)
    }
}
