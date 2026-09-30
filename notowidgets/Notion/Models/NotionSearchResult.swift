//
//  NotionSearchResult.swift
//  notowidgets
//
//  Created by Rachel Cordi on 2026-09-30.
//

import Foundation

struct NotionSearchResult: Decodable, Identifiable {
    let object: String
    let id: String
    let url: String?
    let title: [NotionRichText]?

    var displayTitle: String {
        guard let title, !title.isEmpty else {
            return "Untitled"
        }

        let text = title
            .map { $0.plainText }
            .joined()

        return text.isEmpty ? "Untitled" : text
    }
}

struct NotionRichText: Decodable {
    let plainText: String

    enum CodingKeys: String, CodingKey {
        case plainText = "plain_text"
    }
}
