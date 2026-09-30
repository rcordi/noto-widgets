//
//  ChecklistPreview.swift
//  notowidgets
//
//  Created by Rachel Cordi on 2026-09-30.
//

import SwiftUI

struct ChecklistPreview: View {
    let size: WidgetPreviewSize

    private let tasks = [
        "New Widget Design",
        "Team Meeting",
        "Code Review",
        "Design System Documentation",
        "Books to Read",
        "SwiftUI Learning Notes",
        "Project Planning",
        "Research Notes"
    ]

    var body: some View {
        WidgetPreviewShell(size: size) {
            VStack(alignment: .leading, spacing: rowSpacing) {
                HStack {
                    Text("Today's Tasks")
                        .font(.headline)
                        .fontWeight(.bold)

                    Spacer()

                    Image(systemName: "arrow.clockwise")
                        .foregroundStyle(AppTheme.accent)
                }

                ForEach(Array(tasks.prefix(visibleCount).enumerated()), id: \.offset) { index, task in
                    taskRow(task, complete: index % 4 == 0)
                }
            }
            .foregroundStyle(.white)
        }
    }

    private func taskRow(
        _ title: String,
        complete: Bool
    ) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "doc.text")
                .foregroundStyle(.secondary)

            Text(title)
                .font(.subheadline)
                .lineLimit(1)

            Spacer()

            Image(
                systemName:
                    complete
                    ? "checkmark.square"
                    : "square"
            )
            .font(.title3)
            .foregroundStyle(.secondary)
        }
    }

    private var visibleCount: Int {
        switch size {
        case .small:
            3

        case .medium:
            3

        case .large:
            8
        }
    }

    private var rowSpacing: CGFloat {
        switch size {
        case .small:
            8

        case .medium:
            10

        case .large:
            12
        }
    }
}
