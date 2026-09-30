//
//  NotionDatabaseQueryResponse.swift
//  notowidgets
//
//  Created by Rachel Cordi on 2026-09-30.
//

import Foundation

struct NotionDatabaseQueryResponse: Decodable {
    let results: [NotionPage]
    let hasMore: Bool?
    let nextCursor: String?

    enum CodingKeys: String, CodingKey {
        case results
        case hasMore = "has_more"
        case nextCursor = "next_cursor"
    }
}
