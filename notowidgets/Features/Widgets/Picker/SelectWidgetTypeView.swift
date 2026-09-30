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
        ZStack {
                    AppTheme.background
                        .ignoresSafeArea()

                    VStack(spacing: 0) {
                        header

                        Spacer()
                            .frame(height: 80)

                        widgetDescription

                        Spacer()
                            .frame(height: 34)

                        previewCarousel

                        Spacer()
                            .frame(height: 22)

                        sizeSelector

                        Spacer()
                            .frame(height: 26)

                        pageIndicator

                        Spacer()

                        createButton
                    }
                }
                .preferredColorScheme(.dark)
            }

            private var header: some View {
                ZStack {
                    Text("Select Widget Type")
                        .font(.title3)
                        .fontWeight(.semibold)

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

                        Spacer()
                    }
                }
                .padding(.horizontal, 18)
                .padding(.top, 8)
            }

            private var widgetDescription: some View {
                VStack(spacing: 12) {
                    Text(selectedType.title)
                        .font(.system(size: 30, weight: .bold))

                    Text(selectedType.description)
                        .font(.body)
                        .foregroundStyle(AppTheme.secondaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 38)
                }
            }

            private var previewCarousel: some View {
                TabView(selection: $selectedType) {
                    ForEach(WidgetType.allCases) { type in
                        WidgetPreviewCard(
                            type: type,
                            size: selectedSize
                        )
                        .tag(type)
                    }
                }
                .tabViewStyle(
                    .page(indexDisplayMode: .never)
                )
                .frame(height: carouselHeight)
            }

            private var sizeSelector: some View {
                HStack(spacing: 12) {
                    ForEach(WidgetPreviewSize.allCases) { size in
                        Button {
                            withAnimation(.snappy) {
                                selectedSize = size
                            }
                        } label: {
                            Image(systemName: size.systemImage)
                                .font(.system(size: 22))
                                .foregroundStyle(
                                    selectedSize == size
                                    ? .white
                                    : .secondary
                                )
                                .frame(width: 50, height: 50)
                                .background(
                                    selectedSize == size
                                    ? AppTheme.secondarySurface
                                    : Color.clear
                                )
                                .clipShape(Circle())
                        }
                    }
                }
                .padding(6)
                .background(AppTheme.surface)
                .clipShape(Capsule())
            }

            private var pageIndicator: some View {
                HStack(spacing: 9) {
                    ForEach(WidgetType.allCases) { type in
                        Circle()
                            .fill(
                                selectedType == type
                                ? AppTheme.accent
                                : Color.secondary.opacity(0.5)
                            )
                            .frame(width: 8, height: 8)
                    }
                }
            }

            private var createButton: some View {
                Button {
                    print("Create \(selectedType.title)")
                } label: {
                    Text("Create \(selectedType.title)")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                }
                .foregroundStyle(.white)
                .background(AppTheme.accent)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: AppTheme.cardRadius,
                        style: .continuous
                    )
                )
                .padding(.horizontal, 22)
                .padding(.bottom, 18)
            }

            private var carouselHeight: CGFloat {
                switch selectedSize {
                case .small:
                    200

                case .medium:
                    200

                case .large:
                    370
                }
            }
        }
