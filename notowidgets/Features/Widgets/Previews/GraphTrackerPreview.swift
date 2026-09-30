//
//  GraphTrackerPreview.swift
//  notowidgets
//
//  Created by Rachel Cordi on 2026-09-30.
//

import SwiftUI

struct GraphTrackerPreview: View {
    let size: WidgetPreviewSize

    private let trackers: [(String, String, Int, Int)] = [
        ("Sports", "figure.walk", 7, 12),
        ("Routine", "face.smiling", 12, 23),
        ("Tasks", "checklist", 45, 80),
        ("Study", "book", 5, 10),
        ("Health", "figure.strengthtraining.traditional", 8, 12),
        ("Work", "briefcase", 3, 6)
    ]

    var body: some View {
        WidgetPreviewShell(size: size) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "arrow.clockwise")
                    .foregroundStyle(.secondary)

                trackerLayout
            }
        }
    }

    @ViewBuilder
    private var trackerLayout: some View {
        switch size {
        case .small:
            VStack {
                Spacer()

                progressRing(trackers[0])

                Spacer()
            }
            .frame(maxWidth: .infinity)

        case .medium:
            HStack(spacing: 8) {
                ForEach(Array(trackers.prefix(3).enumerated()), id: \.offset) { _, tracker in
                    progressRing(tracker)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 12)

        case .large:
            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ],
                spacing: 14
            ) {
                ForEach(Array(trackers.prefix(6).enumerated()), id: \.offset) { _, tracker in
                    progressRing(tracker)
                }
            }
            .padding(.top, 12)
        }
    }

    private func progressRing(
        _ tracker: (String, String, Int, Int)
    ) -> some View {
        let progress =
            CGFloat(tracker.2) /
            CGFloat(tracker.3)

        return VStack(spacing: 5) {
            ZStack {
                Circle()
                    .trim(from: 0.12, to: 0.88)
                    .stroke(
                        Color.secondary.opacity(0.30),
                        style: StrokeStyle(
                            lineWidth: ringWidth,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(90))

                Circle()
                    .trim(
                        from: 0.12,
                        to: 0.12 + (0.76 * min(progress, 1))
                    )
                    .stroke(
                        AppTheme.accent,
                        style: StrokeStyle(
                            lineWidth: ringWidth,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(90))

                VStack(spacing: 0) {
                    Text("\(tracker.2)")
                        .font(.system(size: 15, weight: .bold))

                    Text("/ \(tracker.3)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(
                width: ringDiameter,
                height: ringDiameter
            )

            Image(systemName: tracker.1)
                .font(.caption)

            Text(tracker.0)
                .font(.system(size: 10))
                .lineLimit(1)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    private var ringDiameter: CGFloat {
        switch size {
        case .small:
            100

        case .medium:
            68

        case .large:
            70
        }
    }

    private var ringWidth: CGFloat {
        switch size {
        case .small:
            9

        case .medium, .large:
            7
        }
    }
}
