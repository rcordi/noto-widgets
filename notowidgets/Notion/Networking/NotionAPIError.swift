//
//  NotionAPIError.swift
//  notowidgets
//
//  Created by Rachel Cordi on 2026-09-30.
//

import Foundation

enum NotionAPIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case unauthorized
    case requestFailed(statusCode: Int)
    case decodingFailed
    case missingToken

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The Notion API URL is invalid."

        case .invalidResponse:
            return "The Notion API returned an invalid response."

        case .unauthorized:
            return "The Notion integration is not authorized."

        case .requestFailed(let statusCode):
            return "The Notion request failed with status code \(statusCode)."

        case .decodingFailed:
            return "The Notion response could not be decoded."

        case .missingToken:
            return "No Notion integration token is available."
        }
    }
}
