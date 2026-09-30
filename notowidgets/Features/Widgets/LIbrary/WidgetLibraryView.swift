//
//  WidgetLibraryView.swift
//  notowidgets
//
//  Created by Rachel Cordi on 2026-09-29.
//

import SwiftUI

struct WidgetLibraryView: View {
    @State private var showingWidgetPicker = false
    @State private var showingSettings = false

    var body: some View {
        ZStack {
            AppTheme.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                header
                
                Spacer()
                
                emptyState
                
                Spacer()
            }
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showingWidgetPicker) {
            SelectWidgetTypeView()
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }
        
    private var header: some View {
        ZStack {
            Text("Widgets")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
            
            HStack {
                Button {
                    showingWidgetPicker = true
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(AppTheme.surface)
                        .clipShape(Circle())
                }
                Spacer()
                
                Button {
                    showingSettings = true
                } label: {
                    Image(systemName: "gearshape")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(AppTheme.surface)
                        .clipShape(Circle())
                }
            }
        }
        .padding(.horizontal, AppTheme.horizontalPadding)
        .padding(.top, 8)
        .frame(height: 60)
    }
    
    private var emptyState: some View {
        VStack(spacing: 18) {
            Image(systemName: "square.grid.2x2")
                .font(.system(size: 46))
                .foregroundStyle(.secondary)

            Text("No Widgets Yet")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.white)

            Text("Create widgets that connect directly to your Notion databases.")
                .font(.subheadline)
                .foregroundStyle(AppTheme.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 42)

            Button {
                showingWidgetPicker = true
            } label: {
                Label("Create Widget", systemImage: "plus")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
            }
            .foregroundStyle(.white)
            .background(AppTheme.accent)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: AppTheme.buttonRadius,
                    style: .continuous
                )
            )
            .padding(.horizontal, 28)
                
        }
    }
}
