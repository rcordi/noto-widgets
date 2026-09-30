//
//  SettingsView.swift
//  notowidgets
//
//  Created by Rachel Cordi on 2026-09-30.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background
                    .ignoresSafeArea()

                VStack {
                    Text("Settings")
                        .foregroundStyle(.secondary)

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.body)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 18)
                    .frame(height: 46)
                    .background(AppTheme.surface)
                    .clipShape(Capsule())
                    .buttonStyle(PressableButtonStyle())
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
