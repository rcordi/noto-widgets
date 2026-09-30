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
    @State private var updatingPageIDs: Set<String> = []

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
                            Image(systemName: "doc.text")
                                .foregroundStyle(.secondary)

                            Text(page.displayTitle)
                                .font(.subheadline)
                                .foregroundStyle(
                                    page.isComplete
                                    ? AppTheme.secondaryText
                                    : AppTheme.primaryText
                                )
                                .strikethrough(page.isComplete)
                                .lineLimit(1)

                            Spacer()

                            Button {
                                toggleCompletion(for: page)
                            } label: {
                                if updatingPageIDs.contains(page.id) {
                                    ProgressView()
                                        .tint(AppTheme.accent)
                                        .frame(width: 22, height: 22)

                                } else {
                                    Image(
                                        systemName:
                                            page.isComplete
                                            ? "checkmark.square.fill"
                                            : "square"
                                    )
                                    .font(.system(size: 20))
                                    .foregroundStyle(
                                        page.isComplete
                                        ? AppTheme.accent
                                        : AppTheme.secondaryText
                                    )
                                }
                            }
                            .buttonStyle(PressableButtonStyle())
                            .disabled(updatingPageIDs.contains(page.id))
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
            if let firstPage = pages.first {
                print("✅ FIRST TASK:", firstPage.displayTitle)

                for (name, property) in firstPage.properties {
                    print(
                        "PROPERTY:",
                        name,
                        "| TYPE:",
                        property.type ?? "unknown",
                        "| CHECKBOX:",
                        property.checkbox as Any,
                        "| STATUS:",
                        property.status?.name as Any,
                        "| SELECT:",
                        property.select?.name as Any
                    )
                }
            }

            errorMessage = nil
            isLoading = false

        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    private func toggleCompletion(
        for page: NotionPage
    ) {
        guard !updatingPageIDs.contains(page.id) else {
            return
        }

        updatingPageIDs.insert(page.id)

        Task {
            do {
                try await NotionService.shared
                    .setTaskComplete(
                        pageID: page.id,
                        isComplete: !page.isComplete
                    )

                await reloadPages()

            } catch {
                await MainActor.run {
                    errorMessage =
                        error.localizedDescription

                    updatingPageIDs.remove(
                        page.id
                    )
                }
            }
        }
    }
    
    @MainActor
    private func reloadPages() async {
        do {
            pages = try await NotionService.shared
                .fetchPages(
                    from: database.id
                )

            updatingPageIDs.removeAll()

        } catch {
            errorMessage =
                error.localizedDescription

            updatingPageIDs.removeAll()
        }
    }
}
