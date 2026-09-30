//
//  SelectWidgetTypeView.swift
//  notowidgets
//
//  Created by Rachel Cordi on 2026-09-29.
//

import SwiftUI

struct SelectWidgetTypeView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var selectedType: WidgetType = .checklist
    @State private var selectedSize: WidgetPreviewSize = .medium

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background
                    .ignoresSafeArea()

                VStack(spacing: 28) {
                    VStack(spacing: 10) {
                        Image(systemName: selectedType.systemImage)
                            .font(.system(size: 32))
                            .foregroundStyle(AppTheme.accent)

                        Text(selectedType.title)
                            .font(.largeTitle.bold())
                            .foregroundStyle(.white)

                        Text(selectedType.description)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }

                    TabView(selection: $selectedType) {
                        ForEach(WidgetType.allCases) { type in
                            WidgetPreviewCard(
                                type: type,
                                size: selectedSize
                            )
                            .tag(type)
                            .padding(.horizontal, 30)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .frame(height: 280)

                    Picker("Widget Size", selection: $selectedSize) {
                        ForEach(WidgetPreviewSize.allCases) { size in
                            Text(size.title)
                                .tag(size)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)

                    Spacer()

                    Button {
                        print("Create \(selectedType.title)")
                    } label: {
                        Text("Create \(selectedType.title)")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .frame(height: 58)
                    }
                    .foregroundStyle(.white)
                    .background(AppTheme.accent)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: AppTheme.buttonRadius
                        )
                    )
                    .padding(.horizontal, 22)
                    .padding(.bottom)
                }
                .padding(.top, 24)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
