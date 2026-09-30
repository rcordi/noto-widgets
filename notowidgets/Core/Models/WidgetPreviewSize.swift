//
//  WidgetPreviewSize.swift
//  notowidgets
//
//  Created by Rachel Cordi on 2026-09-29.
//

import Foundation

enum WidgetPreviewSize: String, CaseIterable, Identifiable {
    case small
    case medium
    case large

    var id: String { rawValue }

    var title: String {
        rawValue.capitalized
    }

    var systemImage: String {
        switch self {
        case .small: "square"
        case .medium: "rectangle"
        case .large: "square.fill"
        }
    }
}
