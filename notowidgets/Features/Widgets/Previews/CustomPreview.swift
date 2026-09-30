//
//  CustomPreview.swift
//  notowidgets
//
//  Created by Rachel Cordi on 2026-09-30.
//

import SwiftUI

struct CustomPreview: View {
    let size: WidgetPreviewSize

    var body: some View {
        WidgetPreviewShell(size: size) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Custom Widget")
                    .font(.headline)
                    .fontWeight(.bold)

                Text("Build a widget using your own Notion data, layout and actions.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)

                if size != .small {
                    previewRow(
                        icon: "database",
                        text: "Choose data sources"
                    )

                    previewRow(
                        icon: "rectangle.3.group",
                        text: "Choose layout"
                    )
                }

                if size == .large {
                    previewRow(
                        icon: "slider.horizontal.3",
                        text: "Configure properties"
                    )

                    previewRow(
                        icon: "bolt",
                        text: "Configure actions"
                    )

                    previewRow(
                        icon: "paintbrush",
                        text: "Customize appearance"
                    )
                }

                Spacer()
            }
            .foregroundStyle(.white)
        }
    }

    private func previewRow(
        icon: String,
        text: String
    ) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundStyle(.secondary)

            Text(text)
                .font(.subheadline)
                .fontWeight(.regular)

            Spacer()
        }
    }
}
