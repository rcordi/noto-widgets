//
//  PagesPreview.swift
//  notowidgets
//
//  Created by Rachel Cordi on 2026-09-30.
//

import SwiftUI

struct PagesPreview: View {
    let size: WidgetPreviewSize

    private let pages = [
        "New Widget Design",
        "Team Meeting",
        "Code Review",
        "Design System Documentation",
        "Books to Read List",
        "SwiftUI Learning Notes",
        "Project Planning",
        "Research Notes"
    ]

    var body: some View {
        WidgetPreviewShell(size: size) {
            VStack(alignment: .leading, spacing: rowSpacing) {
                HStack {
                    Text("Favorite Pages")
                        .font(.headline)
                        .fontWeight(.bold)

                    Spacer()

                    Image(systemName: "arrow.clockwise")
                        .foregroundStyle(AppTheme.accent)
                }

                ForEach(
                    Array(pages.prefix(visibleCount).enumerated()),
                    id: \.offset
                ) { _, page in
                    HStack(spacing: 10) {
                        Image(systemName: "doc")
                            .foregroundStyle(.secondary)

                        Text(page)
                            .font(.subheadline)
                            .lineLimit(1)

                        Spacer()
                    }
                }
            }
            .foregroundStyle(.white)
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
            9

        case .medium:
            11

        case .large:
            13
        }
    }
}
