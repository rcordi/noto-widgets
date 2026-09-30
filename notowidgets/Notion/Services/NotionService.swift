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
    
    func fetchPages(
        from databaseID: String
    ) async throws -> [NotionPage] {

        let token =
            try NotionTokenStore.shared.getToken()

        let response =
            try await NotionAPIClient.shared
                .queryDatabase(
                    databaseID: databaseID,
                    token: token
                )

        return response.results
    }
    
    func setTaskComplete(
            pageID: String,
            isComplete: Bool
        ) async throws {
            let token = try NotionTokenStore.shared.getToken()

            try await NotionAPIClient.shared
                .updateCheckbox(
                    pageID: pageID,
                    propertyName: "Complete",
                    value: isComplete,
                    token: token
                )
        }
}
