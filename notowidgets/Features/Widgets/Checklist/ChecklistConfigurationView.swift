//
//  ChecklistConfigurationView.swift
//  notowidgets
//
//  Created by Rachel Cordi on 2026-09-30.
//

import SwiftUI

struct ChecklistConfigurationView: View {
    @Environment(\.dismiss) private var dismiss

    let database: NotionSearchResult

    @State private var pages: [NotionPage] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var hasLoaded = false

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
                        Image(
                            systemName:
                                "exclamationmark.circle"
                        )
                        .font(.title2)

                        Text(errorMessage)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()

                    Spacer()

                } else {
                    content
                }
            }
        }
        .preferredColorScheme(.dark)
        .task {
            await loadPages()
        }
    }

    private var header: some View {
        ZStack {
            Text("Checklist")
                .font(.system(
                    size: 18,
                    weight: .semibold
                ))

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
                .buttonStyle(
                    PressableButtonStyle()
                )

                Spacer()
            }
        }
        .padding(.horizontal, 18)
        .frame(height: 50)
    }

    private var content: some View {
        ScrollView {
            VStack(
                alignment: .leading,
                spacing: 18
            ) {
                VStack(
                    alignment: .leading,
                    spacing: 4
                ) {
                    Text("Database")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text(database.displayTitle)
                        .font(.headline)
                }

                Text("Preview Items")
                    .font(.headline)

                VStack(spacing: 10) {
                    ForEach(pages) { page in
                        HStack(spacing: 10) {
                            Image(
                                systemName: "doc.text"
                            )
                            .foregroundStyle(.secondary)

                            Text(page.displayTitle)
                                .font(.subheadline)
                                .lineLimit(1)

                            Spacer()

                            Image(
                                systemName: "square"
                            )
                            .foregroundStyle(.secondary)
                        }
                        .padding(.horizontal, 14)
                        .frame(height: 50)
                        .background(AppTheme.surface)
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 12,
                                style: .continuous
                            )
                        )
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }

    @MainActor
    private func loadPages() async {
        do {
            pages = try await NotionService.shared
                .fetchPages(
                    from: database.id
                )

            errorMessage = nil
            isLoading = false

        } catch is CancellationError {
            // Ignore expected task cancellation.

        } catch let error as URLError
            where error.code == .cancelled {

            // Ignore URLSession cancellation.

        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
}
