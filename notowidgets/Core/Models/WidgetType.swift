//
//  WidgetType.swift
//  notowidgets
//
//  Created by Rachel Cordi on 2026-09-29.
//

import Foundation

enum WidgetType: String, Codable, CaseIterable, Identifiable {
    case quickAdd
    case checklist
    case graphTracker
    case calendar
    case pages
    case custom

    var id: String { rawValue }

    var title: String {
        switch self {
        case .quickAdd: "Quick Add"
        case .checklist: "Checklist"
        case .graphTracker: "Graph & Tracker"
        case .calendar: "Calendar"
        case .pages: "Pages"
        case .custom: "Custom"
        }
    }

    var description: String {
        switch self {
        case .quickAdd:
            "Create pages across one or multiple Notion databases."
        case .checklist:
            "View and complete items from a single database."
        case .graphTracker:
            "Track habits, goals, progress, counts, and trends."
        case .calendar:
            "Combine dated items from one or multiple databases."
        case .pages:
            "Quick access to favorite or dynamically selected pages."
        case .custom:
            "Build a widget with your own data, layout, and actions."
        }
    }

    var systemImage: String {
        switch self {
        case .quickAdd: "plus.circle"
        case .checklist: "checklist"
        case .graphTracker: "chart.line.uptrend.xyaxis"
        case .calendar: "calendar"
        case .pages: "doc.on.doc"
        case .custom: "slider.horizontal.3"
        }
    }
}
