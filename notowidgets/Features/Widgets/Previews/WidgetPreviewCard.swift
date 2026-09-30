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
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: type.systemImage)

                Text(type.title)
                    .font(.headline)

                Spacer()
            }

            previewContent
        }
        .foregroundStyle(.white)
        .padding(18)
        .frame(
            maxWidth: previewWidth,
            minHeight: previewHeight
        )
        .background(AppTheme.surface)
        .clipShape(
            RoundedRectangle(
                cornerRadius: AppTheme.cardRadius
            )
        )
    }

    @ViewBuilder
    private var previewContent: some View {
        switch type {
        case .quickAdd:
            HStack {
                previewAction("Task", icon: "checkmark.circle")
                previewAction("Note", icon: "note.text")
                previewAction("Event", icon: "calendar")
            }

        case .checklist:
            VStack(spacing: 10) {
                checklistRow("Review lecture notes")
                checklistRow("Finish assignment")
                checklistRow("Career application")
            }

        case .graphTracker:
            HStack {
                progressRing(title: "Strength", value: 2, target: 3)
                progressRing(title: "Study", value: 4, target: 5)
                progressRing(title: "Read", value: 3, target: 3)
            }

        case .calendar:
            VStack(alignment: .leading, spacing: 10) {
                Text("Today")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text("10:00  MATH Lecture")
                Text("2:00   Study Block")
                Text("6:30   Salsa")
            }

        case .pages:
            VStack(alignment: .leading, spacing: 12) {
                Label("Home", systemImage: "house")
                Label("Courses", systemImage: "book")
                Label("Projects", systemImage: "hammer")
            }

        case .custom:
            VStack(alignment: .leading, spacing: 8) {
                Text("Build your own")
                    .font(.headline)

                Text("Choose data, layout, properties and actions.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func checklistRow(_ title: String) -> some View {
        HStack {
            Image(systemName: "circle")
            Text(title)
            Spacer()
        }
    }

    private func previewAction(
        _ title: String,
        icon: String
    ) -> some View {
        VStack(spacing: 7) {
            Image(systemName: icon)
                .font(.title3)

            Text(title)
                .font(.caption)
        }
        .frame(maxWidth: .infinity)
    }

    private func progressRing(
        title: String,
        value: Int,
        target: Int
    ) -> some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .stroke(
                        Color.secondary.opacity(0.25),
                        lineWidth: 7
                    )

                Circle()
                    .trim(
                        from: 0,
                        to: min(
                            CGFloat(value) /
                            CGFloat(target),
                            1
                        )
                    )
                    .stroke(
                        AppTheme.accent,
                        style: StrokeStyle(
                            lineWidth: 7,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))

                Text("\(value)/\(target)")
                    .font(.caption.bold())
            }
            .frame(width: 58, height: 58)

            Text(title)
                .font(.caption2)
        }
        .frame(maxWidth: .infinity)
    }

    private var previewWidth: CGFloat {
        switch size {
        case .small: 180
        case .medium: 350
        case .large: 350
        }
    }

    private var previewHeight: CGFloat {
        switch size {
        case .small: 180
        case .medium: 180
        case .large: 330
        }
    }
}
