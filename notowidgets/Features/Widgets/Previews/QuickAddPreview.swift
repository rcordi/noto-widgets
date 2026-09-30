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
                    .font(.system(size: size == .large ? 16 : 14, weight: .bold))

                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 6),
                        GridItem(.flexible(), spacing: 6)
                    ],
                    spacing: 6
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
            VStack(spacing: 2) {
                Image(systemName: icon)
                    .font(.system(size: 15))
                    .frame(width: 34, height: 34)
                    .background(AppTheme.secondarySurface)
                    .clipShape(Circle())

                Text(title)
                    .font(.system(size: 9))
                    .lineLimit(1)
                    .minimumScaleFactor(0.65)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)

        } else if size == .medium {
            HStack(spacing: 7) {
                Image(systemName: icon)
                    .font(.system(size: 13))

                Text(title)
                    .font(.system(size: 12))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Spacer()
            }
            .padding(.horizontal, 9)
            .frame(height: 34)
            .background(AppTheme.secondarySurface)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 9,
                    style: .continuous
                )
            )
        } else {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14))

                Text(title)
                    .font(.system(size: 13))
                    .lineLimit(1)

                Spacer()
            }
            .padding(.horizontal, 10)
            .frame(height: 38)
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
            4

        case .large:
            10
        }
    }
}
