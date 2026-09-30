//
//  NotionBotUser.swift
//  notowidgets
//
//  Created by Rachel Cordi on 2026-09-30.
//

import Foundation

struct NotionBotUser: Decodable {
    let object: String
    let id: String
    let name: String?
}
