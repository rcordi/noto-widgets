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
    @State private var localCompletion: [String: Bool] = [:]

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
                                    completionState(for: page)
                                    ? AppTheme.secondaryText
                                    : AppTheme.primaryText
                                )
                                .strikethrough(completionState(for: page))
                                .lineLimit(1)

                            Spacer()

                            Button {
                                toggleCompletion(for: page)
                            } label: {
                                Image(
                                    systemName:
                                        completionState(for: page)
                                        ? "checkmark.square.fill"
                                        : "square"
                                )
                                .font(.system(size: 20))
                                .foregroundStyle(
                                    completionState(for: page)
                                    ? AppTheme.accent
                                    : AppTheme.secondaryText
                                )
                                .opacity(
                                    updatingPageIDs.contains(page.id)
                                    ? 0.6
                                    : 1
                                )
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

        let oldValue = completionState(for: page)
        let newValue = !oldValue

        // Update UI immediately
        localCompletion[page.id] = newValue
        updatingPageIDs.insert(page.id)

        Task {
            do {
                try await NotionService.shared
                    .setTaskComplete(
                        pageID: page.id,
                        isComplete: newValue
                    )

                await MainActor.run {
                    updatingPageIDs.remove(page.id)
                    errorMessage = nil
                }

            } catch {
                await MainActor.run {
                    // Roll back UI if Notion update fails
                    localCompletion[page.id] = oldValue
                    updatingPageIDs.remove(page.id)

                    errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    private func completionState(for page: NotionPage) -> Bool {
        localCompletion[page.id] ?? page.isComplete
    }
    
}
