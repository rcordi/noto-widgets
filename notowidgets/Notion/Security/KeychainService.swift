//
//  KeychainService.swift
//  notowidgets
//
//  Created by Rachel Cordi on 2026-09-30.
//

import Foundation
import Security

final class KeychainService {
    static let shared = KeychainService()

    private init() {}

    func save(
        _ value: String,
        for key: String
    ) throws {
        let data = Data(value.utf8)

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]

        SecItemDelete(query as CFDictionary)

        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]

        let status = SecItemAdd(
            attributes as CFDictionary,
            nil
        )

        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status)
        }
    }

    func read(
        for key: String
    ) throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var item: CFTypeRef?

        let status = SecItemCopyMatching(
            query as CFDictionary,
            &item
        )

        if status == errSecItemNotFound {
            return nil
        }

        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status)
        }

        guard
            let data = item as? Data,
            let value = String(data: data, encoding: .utf8)
        else {
            return nil
        }

        return value
    }

    func delete(
        for key: String
    ) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]

        let status = SecItemDelete(query as CFDictionary)

        guard status == errSecSuccess ||
                status == errSecItemNotFound
        else {
            throw KeychainError.unhandledError(status)
        }
    }
}

enum KeychainError: Error {
    case unhandledError(OSStatus)
}
