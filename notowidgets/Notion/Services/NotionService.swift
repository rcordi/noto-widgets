//
//  NotionService.swift
//  notowidgets
//
//  Created by Rachel Cordi on 2026-09-30.
//

import Foundation

final class NotionService {
    static let shared = NotionService()

    private init() {}

    func fetchAccessibleContent() async throws -> [NotionSearchResult] {
        let token = try NotionTokenStore.shared.getToken()

        let response = try await NotionAPIClient.shared
            .searchWorkspace(token: token)

        return response.results
    }

    func fetchDatabases() async throws -> [NotionSearchResult] {
        let results = try await fetchAccessibleContent()

        return results.filter {
            $0.object == "database"
        }
    }
}
