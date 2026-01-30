//
//  NSAttributedString.swift
//  TestAnaghtech
//
//  Created by Vladislav Murygin on 2/12/25.
//

import Foundation
import SwiftUI

extension NSAttributedString {

    static func html(withBody body: String) -> NSAttributedString {
        let bundle = Bundle.main
        let lang = bundle.preferredLocalizations.first
            ?? bundle.developmentLocalization
            ?? "en"

        let html = """
        <!doctype html>
        <html lang="\(lang)">
        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">

            <style type="text/css">
                body {
                    font: -apple-system-body;
                    color: \(UIColor.secondaryLabel.hex);
                    margin: 0;
                    padding: 0;
                }

                h1, h2, h3, h4, h5, h6 {
                    color: \(UIColor.label.hex);
                }

                a {
                    color: \(UIColor.systemGreen.hex);
                    word-break: break-word;
                }

                img {
                    max-width: 100%;
                    height: auto;
                    display: block;
                }

                p {
                    margin: 0 0 0.75em 0;
                }

                li:last-child {
                    margin-bottom: 1em;
                }
            </style>
        </head>
        <body>
            \(body)
        </body>
        </html>
        """

        guard let data = html.data(using: .utf8) else {
            return NSAttributedString(string: body)
        }

        return (try? NSAttributedString(
            data: data,
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil
        )) ?? NSAttributedString(string: body)
    }
}
