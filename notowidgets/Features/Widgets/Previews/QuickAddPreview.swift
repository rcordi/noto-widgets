//
//  QuickAddPreview.swift
//  notowidgets
//
//  Created by Rachel Cordi on 2026-09-30.
//

import SwiftUI

struct QuickAddPreview: View {
    let size: WidgetPreviewSize

    private let actions: [(String, String)] = [
        ("Idea Note", "square.and.pencil"),
        ("Add Task", "checkmark.circle"),
        ("Reading Log", "book"),
        ("New Event", "calendar"),
        ("Resource", "bookmark"),
        ("Project", "folder"),
        ("Journal", "pencil.line"),
        ("Workout", "figure.strengthtraining.traditional"),
        ("Contact", "person"),
        ("Other", "plus")
    ]

    var body: some View {
        WidgetPreviewShell(size: size) {
            VStack(alignment: .leading, spacing: 14) {
                Text("Quick Add")
                    .font(.headline)
                    .fontWeight(.bold)

                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 10),
                        GridItem(.flexible(), spacing: 10)
                    ],
                    spacing: 10
                ) {
                    ForEach(Array(actions.prefix(visibleCount).enumerated()), id: \.offset) { _, action in
                        actionButton(
                            title: action.0,
                            icon: action.1
                        )
                    }
                }
            }
            .foregroundStyle(.white)
        }
    }

    @ViewBuilder
    private func actionButton(
        title: String,
        icon: String
    ) -> some View {
        if size == .small {
            VStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.title3)
                    .frame(width: 42, height: 42)
                    .background(AppTheme.secondarySurface)
                    .clipShape(Circle())

                Text(title)
                    .font(.caption2)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)

        } else {
            HStack(spacing: 8) {
                Image(systemName: icon)

                Text(title)
                    .font(.subheadline)
                    .lineLimit(1)

                Spacer()
            }
            .padding(.horizontal, 10)
            .frame(height: size == .large ? 42 : 36)
            .background(AppTheme.secondarySurface)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 10,
                    style: .continuous
                )
            )
        }
    }

    private var visibleCount: Int {
        switch size {
        case .small:
            4

        case .medium:
            6

        case .large:
            10
        }
    }
}
