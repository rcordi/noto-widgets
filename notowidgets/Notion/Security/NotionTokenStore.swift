//
//  NotionTokenStore.swift
//  notowidgets
//
//  Created by Rachel Cordi on 2026-09-30.
//

import Foundation

final class NotionTokenStore {
    static let shared = NotionTokenStore()

    private let tokenKey = "notion.integration.token"

    private init() {}

    func saveToken(_ token: String) throws {
        let cleanedToken = token.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !cleanedToken.isEmpty else {
            throw NotionAPIError.missingToken
        }

        try KeychainService.shared.save(
            cleanedToken,
            for: tokenKey
        )
    }

    func getToken() throws -> String {
        guard
            let token = try KeychainService.shared.read(
                for: tokenKey
            ),
            !token.isEmpty
        else {
            throw NotionAPIError.missingToken
        }

        return token
    }

    func deleteToken() throws {
        try KeychainService.shared.delete(
            for: tokenKey
        )
    }
}
