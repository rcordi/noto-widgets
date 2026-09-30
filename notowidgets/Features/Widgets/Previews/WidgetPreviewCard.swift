//
//  WidgetPreviewCard.swift
//  notowidgets
//
//  Created by Rachel Cordi on 2026-09-29.
//

import SwiftUI

struct WidgetPreviewCard: View {
    let type: WidgetType
    let size: WidgetPreviewSize

    var body: some View {
        switch type {
        case .quickAdd:
            QuickAddPreview(size: size)

        case .checklist:
            ChecklistPreview(size: size)

        case .graphTracker:
            GraphTrackerPreview(size: size)

        case .calendar:
            CalendarPreview(size: size)

        case .pages:
            PagesPreview(size: size)

        case .custom:
            CustomPreview(size: size)
        }
    }
}
        
