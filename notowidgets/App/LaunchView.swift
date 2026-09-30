//
//  LaunchView.swift
//  notowidgets
//
//  Created by Rachel Cordi on 2026-09-30.
//

import SwiftUI

struct LaunchView: View {
    var body: some View {
        ZStack {
            AppTheme.background
                .ignoresSafeArea()

            Image(systemName: "square.grid.2x2.fill")
                .font(.system(size: 70, weight: .medium))
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    LaunchView()
}
