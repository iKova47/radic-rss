//
//  String+XMLEntities.swift
//  Radic
//
//  Created by Ivan Kovacevic on 29.06.2021..
//

import Foundation

// This is not the full list of the codes, just a handful of selected ones I decided to support
private let xmlEntities = [
    "&amp;": "&",
    "&quot;": "\"",
    "&#39;": "\'",
    "&gt;": ">",
    "&lt;": "<",
    "&#8217;": "’",
    "&#62;": ">",
    "&#8220;": "“"
]

extension String {

    // This is a terrible way for converting a large number of the HTML, hex or decimal codes into readable symbols...
    // The real app would use a better solution, but I can't figure it out now since my time with this project is limited 
    func xmlUnescaped() -> String {
        var value = self

        for entity in xmlEntities {
            value = value.replacingOccurrences(of: entity.key, with: entity.value)
        }

        return value
    }

    func removingHTMLElements() -> String {
        replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
