//
//  NotionAPIClient.swift
//  notowidgets
//
//  Created by Rachel Cordi on 2026-09-30.
//

import Foundation

final class NotionAPIClient {
    static let shared = NotionAPIClient()

    private let baseURL = "https://api.notion.com/v1"

    private init() {}

    func makeRequest(
        endpoint: String,
        method: String = "GET",
        token: String
    ) throws -> URLRequest {

        guard let url = URL(string: baseURL + endpoint) else {
            throw NotionAPIError.invalidURL
        }

        var request = URLRequest(url: url)

        request.httpMethod = method

        request.setValue(
            "Bearer \(token)",
            forHTTPHeaderField: "Authorization"
        )

        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )

        request.setValue(
            "2022-06-28",
            forHTTPHeaderField: "Notion-Version"
        )

        return request
    }

    func performRequest(
        endpoint: String,
        method: String = "GET",
        token: String
    ) async throws -> Data {

        let request = try makeRequest(
            endpoint: endpoint,
            method: method,
            token: token
        )

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NotionAPIError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200...299:
            return data

        case 401:
            throw NotionAPIError.unauthorized

        default:
            throw NotionAPIError.requestFailed(
                statusCode: httpResponse.statusCode
            )
        }
    }
    
    func testConnection(
        token: String
    ) async throws -> NotionBotUser {

        let data = try await performRequest(
            endpoint: "/users/me",
            token: token
        )

        do {
            return try JSONDecoder().decode(
                NotionBotUser.self,
                from: data
            )
        } catch {
            throw NotionAPIError.decodingFailed
        }
    }
    
    func searchWorkspace(
        token: String
    ) async throws -> NotionSearchResponse {

        guard let url = URL(
            string: baseURL + "/search"
        ) else {
            throw NotionAPIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        request.setValue(
            "Bearer \(token)",
            forHTTPHeaderField: "Authorization"
        )

        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )

        request.setValue(
            "2022-06-28",
            forHTTPHeaderField: "Notion-Version"
        )

        request.httpBody = try JSONSerialization.data(
            withJSONObject: [
                "page_size": 100
            ]
        )

        let (data, response) =
            try await URLSession.shared.data(
                for: request
            )

        guard let httpResponse =
            response as? HTTPURLResponse
        else {
            throw NotionAPIError.invalidResponse
        }

        switch httpResponse.statusCode {

        case 200...299:
            do {
                return try JSONDecoder().decode(
                    NotionSearchResponse.self,
                    from: data
                )
            } catch {
                print("❌ NOTION DECODING ERROR:")
                print(error)

                print("❌ NOTION RAW RESPONSE:")
                print(
                    String(
                        data: data,
                        encoding: .utf8
                    ) ?? "Could not display response"
                )

                throw NotionAPIError.decodingFailed
            }

        case 401:
            throw NotionAPIError.unauthorized

        default:
            throw NotionAPIError.requestFailed(
                statusCode: httpResponse.statusCode
            )
        }
    }
    
    func queryDatabase(
        databaseID: String,
        token: String
    ) async throws -> NotionDatabaseQueryResponse {

        guard let url = URL(
            string: baseURL + "/databases/\(databaseID)/query"
        ) else {
            throw NotionAPIError.invalidURL
        }

        var request = URLRequest(url: url)

        request.httpMethod = "POST"

        request.setValue(
            "Bearer \(token)",
            forHTTPHeaderField: "Authorization"
        )

        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )

        request.setValue(
            "2022-06-28",
            forHTTPHeaderField: "Notion-Version"
        )

        request.httpBody = try JSONSerialization.data(
            withJSONObject: [
                "page_size": 100
            ]
        )

        let (data, response) =
            try await URLSession.shared.data(
                for: request
            )

        guard let httpResponse =
            response as? HTTPURLResponse
        else {
            throw NotionAPIError.invalidResponse
        }

        switch httpResponse.statusCode {

        case 200...299:
            do {
                return try JSONDecoder().decode(
                    NotionDatabaseQueryResponse.self,
                    from: data
                )
            } catch {
                print("❌ DATABASE DECODING ERROR:")
                print(error)

                print("❌ DATABASE RAW RESPONSE:")
                print(
                    String(
                        data: data,
                        encoding: .utf8
                    ) ?? ""
                )

                throw NotionAPIError.decodingFailed
            }

        case 401:
            throw NotionAPIError.unauthorized

        default:
            throw NotionAPIError.requestFailed(
                statusCode: httpResponse.statusCode
            )
        }
    }
    
    func updateCheckbox(
        pageID: String,
        propertyName: String,
        value: Bool,
        token: String
    ) async throws {

        guard let url = URL(
            string: baseURL + "/pages/\(pageID)"
        ) else {
            throw NotionAPIError.invalidURL
        }

        var request = URLRequest(url: url)

        request.httpMethod = "PATCH"

        request.setValue(
            "Bearer \(token)",
            forHTTPHeaderField: "Authorization"
        )

        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )

        request.setValue(
            "2022-06-28",
            forHTTPHeaderField: "Notion-Version"
        )

        request.httpBody = try JSONSerialization.data(
            withJSONObject: [
                "properties": [
                    propertyName: [
                        "checkbox": value
                    ]
                ]
            ]
        )

        let (_, response) =
            try await URLSession.shared.data(
                for: request
            )

        guard let httpResponse =
            response as? HTTPURLResponse
        else {
            throw NotionAPIError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200...299:
            return

        case 401:
            throw NotionAPIError.unauthorized

        default:
            throw NotionAPIError.requestFailed(
                statusCode: httpResponse.statusCode
            )
        }
    }
}
