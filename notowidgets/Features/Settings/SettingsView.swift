//
//  SettingsView.swift
//  notowidgets
//
//  Created by Rachel Cordi on 2026-09-30.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var notionToken = ""

    @State private var connectionStatus:
        ConnectionStatus = .notTested

    @State private var isTesting = false
    
    @State private var notionResults: [NotionSearchResult] = []
    @State private var isLoadingContent = false

    var body: some View {
        ZStack {
            AppTheme.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                header

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        notionSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                }
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            loadStoredToken()
        }
    }

    private var header: some View {
        ZStack {
            Text("Settings")
                .font(.system(size: 18, weight: .semibold))

            HStack {
                Spacer()

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
        .padding(.horizontal, 18)
        .frame(height: 50)
    }

    private var notionSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Notion")
                .font(.headline)

            Text(
                "Connect a Notion integration while we develop the app."
            )
            .font(.subheadline)
            .foregroundStyle(AppTheme.secondaryText)

            SecureField(
                "Notion integration token",
                text: $notionToken
            )
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .padding(.horizontal, 14)
            .frame(height: 50)
            .background(AppTheme.surface)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 14,
                    style: .continuous
                )
            )

            Button {
                saveToken()
            } label: {
                Text("Save Token")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
            }
            .foregroundStyle(.white)
            .background(AppTheme.surface)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 14,
                    style: .continuous
                )
            )
            .buttonStyle(PressableButtonStyle())

            Button {
                testConnection()
            } label: {
                HStack {
                    if isTesting {
                        ProgressView()
                            .tint(.white)
                    }

                    Text(
                        isTesting
                        ? "Testing..."
                        : "Test Connection"
                    )
                    .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 48)
            }
            .foregroundStyle(.white)
            .background(AppTheme.accent)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 14,
                    style: .continuous
                )
            )
            .buttonStyle(PressableButtonStyle())
            .disabled(isTesting)

            Button {
                loadNotionContent()
            } label: {
                HStack {
                    if isLoadingContent {
                        ProgressView()
                            .tint(.white)
                    }

                    Text(
                        isLoadingContent
                        ? "Loading..."
                        : "Load Notion Content"
                    )
                    .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 48)
            }
            .foregroundStyle(.white)
            .background(AppTheme.surface)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 14,
                    style: .continuous
                )
            )
            .buttonStyle(PressableButtonStyle())
            .disabled(isLoadingContent)
            
            if !notionResults.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Accessible Content")
                        .font(.subheadline)
                        .fontWeight(.semibold)

                    ForEach(notionResults) { result in
                        HStack(spacing: 10) {
                            Image(
                                systemName:
                                    result.object == "database"
                                    ? "tablecells"
                                    : "doc.text"
                            )
                            .foregroundStyle(.secondary)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(result.displayTitle)
                                    .font(.subheadline)
                                    .lineLimit(1)

                                Text(result.object.capitalized)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()
                        }
                        .padding(.vertical, 4)
                    }
                }
                .padding(.top, 6)
            }
            
            connectionStatusView
            
            
        }
    }

    @ViewBuilder
    private var connectionStatusView: some View {
        switch connectionStatus {

        case .notTested:
            EmptyView()

        case .connected(let name):
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")

                Text(
                    name.isEmpty
                    ? "Connected to Notion"
                    : "Connected as \(name)"
                )
            }
            .font(.subheadline)
            .foregroundStyle(.green)

        case .failed(let message):
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "exclamationmark.circle.fill")

                Text(message)
            }
            .font(.subheadline)
            .foregroundStyle(.red)
        }
    }

    private func saveToken() {
        do {
            try NotionTokenStore.shared.saveToken(
                notionToken
            )

            connectionStatus = .notTested

        } catch {
            connectionStatus = .failed(
                error.localizedDescription
            )
        }
    }

    private func loadStoredToken() {
        do {
            notionToken =
                try NotionTokenStore.shared.getToken()

        } catch {
            notionToken = ""
        }
    }

    private func testConnection() {
        isTesting = true

        Task {
            do {
                try NotionTokenStore.shared.saveToken(
                    notionToken
                )

                let token =
                    try NotionTokenStore.shared.getToken()

                let user =
                    try await NotionAPIClient.shared
                        .testConnection(token: token)

                await MainActor.run {
                    connectionStatus = .connected(
                        user.name ?? ""
                    )

                    isTesting = false
                }

            } catch {
                await MainActor.run {
                    connectionStatus = .failed(
                        error.localizedDescription
                    )

                    isTesting = false
                }
            }
        }
    }
    
    private func loadNotionContent() {
        isLoadingContent = true
        notionResults = []

        Task {
            do {
                let token =
                    try NotionTokenStore.shared.getToken()

                let response =
                    try await NotionAPIClient.shared
                        .searchWorkspace(token: token)

                await MainActor.run {
                    notionResults = response.results
                    isLoadingContent = false
                }

            } catch {
                await MainActor.run {
                    connectionStatus = .failed(
                        error.localizedDescription
                    )

                    isLoadingContent = false
                }
            }
        }
    }
}

private enum ConnectionStatus {
    case notTested
    case connected(String)
    case failed(String)
}
