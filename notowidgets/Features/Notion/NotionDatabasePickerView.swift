//
//  NotionDatabasePickerView.swift
//  notowidgets
//
//  Created by Rachel Cordi on 2026-09-30.
//

import SwiftUI

struct NotionDatabasePickerView: View {
    @Environment(\.dismiss) private var dismiss

    let onSelect: (NotionSearchResult) -> Void

    @State private var databases: [NotionSearchResult] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        ZStack {
            AppTheme.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                header

                if isLoading {
                    Spacer()

                    ProgressView()
                        .tint(.white)

                    Spacer()

                } else if let errorMessage {
                    Spacer()

                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.circle")
                            .font(.title2)

                        Text(errorMessage)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()

                    Spacer()

                } else if databases.isEmpty {
                    Spacer()

                    Text("No accessible databases found.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Spacer()

                } else {
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(databases) { database in
                                Button {
                                    onSelect(database)
                                    dismiss()
                                } label: {
                                    HStack(spacing: 12) {
                                        Image(systemName: "tablecells")
                                            .foregroundStyle(.secondary)

                                        Text(database.displayTitle)
                                            .font(.body)
                                            .foregroundStyle(.white)

                                        Spacer()

                                        Image(systemName: "chevron.right")
                                            .foregroundStyle(.secondary)
                                    }
                                    .padding(.horizontal, 14)
                                    .frame(height: 54)
                                    .background(AppTheme.surface)
                                    .clipShape(
                                        RoundedRectangle(
                                            cornerRadius: 14,
                                            style: .continuous
                                        )
                                    )
                                }
                                .buttonStyle(PressableButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
        .task {
            await loadDatabases()
        }
    }

    private var header: some View {
        ZStack {
            Text("Choose Database")
                .font(.system(size: 18, weight: .semibold))

            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .font(.body)
                .foregroundStyle(.white)
                .padding(.horizontal, 18)
                .frame(height: 46)
                .background(AppTheme.surface)
                .clipShape(Capsule())
                .buttonStyle(PressableButtonStyle())

                Spacer()
            }
        }
        .padding(.horizontal, 18)
        .frame(height: 50)
    }

    @MainActor
    private func loadDatabases() async {
        do {
            databases = try await NotionService.shared.fetchDatabases()
            isLoading = false

        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
}
