//
//  NotionPage.swift
//  notowidgets
//
//  Created by Rachel Cordi on 2026-09-30.
//

import Foundation

struct NotionPage: Decodable, Identifiable {
    let id: String
    let url: String?
    let properties: [String: NotionPageProperty]

    var displayTitle: String {
        for property in properties.values {
            if let title = property.title,
               !title.isEmpty {

                let text = title
                    .map { $0.plainText }
                    .joined()

                if !text.isEmpty {
                    return text
                }
            }
        }

        return "Untitled"
    }
}

struct NotionPageProperty: Decodable {
    let id: String?
    let type: String?

    let title: [NotionRichText]?
    let checkbox: Bool?

    let status: NotionStatusValue?
    let select: NotionSelectValue?

    let date: NotionDateValue?
}

struct NotionStatusValue: Decodable {
    let id: String?
    let name: String?
    let color: String?
}

struct NotionSelectValue: Decodable {
    let id: String?
    let name: String?
    let color: String?
}

struct NotionDateValue: Decodable {
    let start: String?
    let end: String?
    let timeZone: String?

    enum CodingKeys: String, CodingKey {
        case start
        case end
        case timeZone = "time_zone"
    }
}
