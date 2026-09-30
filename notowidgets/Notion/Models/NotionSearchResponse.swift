//
//  NotionSearchResponse.swift
//  notowidgets
//
//  Created by Rachel Cordi on 2026-09-30.
//

import Foundation

struct NotionSearchResponse: Decodable {
    let results: [NotionSearchResult]
    let hasMore: Bool?
    let nextCursor: String?

    enum CodingKeys: String, CodingKey {
        case results
        case hasMore = "has_more"
        case nextCursor = "next_cursor"
    }
}
