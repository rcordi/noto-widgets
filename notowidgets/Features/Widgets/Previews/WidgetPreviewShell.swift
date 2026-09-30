//
//  WidgetPreviewShell.swift
//  notowidgets
//
//  Created by Rachel Cordi on 2026-09-30.
//

import SwiftUI

struct WidgetPreviewShell<Content: View>: View {
    let size: WidgetPreviewSize
    private let content: Content

    init(
        size: WidgetPreviewSize,
        @ViewBuilder content: () -> Content
    ) {
        self.size = size
        self.content = content()
    }

    var body: some View {
        content
            .padding(contentPadding)
            .frame(
                width: previewWidth,
                height: previewHeight,
                alignment: .topLeading
            )
            .background(AppTheme.surface)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: AppTheme.cardRadius,
                    style: .continuous
                )
            )
    }

    private var previewWidth: CGFloat {
        switch size {
        case .small:
            160

        case .medium, .large:
            340
        }
    }

    private var previewHeight: CGFloat {
        switch size {
        case .small, .medium:
            160

        case .large:
            340
        }
    }

    private var contentPadding: CGFloat {
        switch size {
        case .small:
            12

        case .medium:
            14

        case .large:
            16
        }
    }
}
