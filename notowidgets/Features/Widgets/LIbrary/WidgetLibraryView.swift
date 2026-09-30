//
//  WidgetLibraryView.swift
//  notowidgets
//
//  Created by Rachel Cordi on 2026-09-29.
//

import SwiftUI

struct WidgetLibraryView: View {
    @State private var showingWidgetPicker = false

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Spacer()

                    Image(systemName: "square.grid.2x2")
                        .font(.system(size: 52))
                        .foregroundStyle(.secondary)

                    Text("No Widgets Yet")
                        .font(.title2.bold())
                        .foregroundStyle(.white)

                    Text("Create widgets that connect directly to your Notion databases.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)

                    Button {
                        showingWidgetPicker = true
                    } label: {
                        Label("Create Widget", systemImage: "plus")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                    }
                    .foregroundStyle(.white)
                    .background(AppTheme.accent)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: AppTheme.buttonRadius
                        )
                    )
                    .padding(.horizontal, 28)

                    Spacer()
                }
            }
            .navigationTitle("Widgets")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingWidgetPicker = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingWidgetPicker) {
                SelectWidgetTypeView()
            }
        }
        .preferredColorScheme(.dark)
    }
}
