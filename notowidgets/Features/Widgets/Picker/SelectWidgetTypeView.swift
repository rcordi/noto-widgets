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
                    .frame(height: 42)
                
                widgetDescription
                
                Spacer()
                    .frame(height: 18)
                
                previewCarousel
                
                Spacer()
                    .frame(height: 14)
                
                sizeSelector
                
                Spacer()
                    .frame(height: 16)
                
                pageIndicator
                
                Spacer()
                    .frame(minHeight: 10)
                
                createButton
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private var header: some View {
        ZStack {
            Text("Select Widget Type")
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
        .padding(.top, 0)
        .frame(height: 50)
    }
    
    private var widgetDescription: some View {
        VStack(spacing: 8) {
            Text(selectedType.title)
                .font(.system(size: 24, weight: .bold))
            
            Text(selectedType.description)
                .font(.system(size: 14))
                .foregroundStyle(AppTheme.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 36)
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
        .frame(maxWidth: .infinity)
        .frame(height: 355)
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
                        .font(.system(size: 20))
                        .foregroundStyle(
                            selectedSize == size
                            ? .white
                            : .secondary
                        )
                        .frame(width: 44, height: 44)
                        .background(
                            selectedSize == size
                            ? AppTheme.secondarySurface
                            : Color.clear
                        )
                        .clipShape(Circle())
                } .buttonStyle(PressableButtonStyle())
            }
        }
        .padding(4)
        .background(AppTheme.surface)
        .clipShape(Capsule())
    }
    
    private var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(WidgetType.allCases) { type in
                Circle()
                    .fill(
                        selectedType == type
                        ? AppTheme.accent
                        : Color.secondary.opacity(0.5)
                    )
                    .frame(width: 7, height: 7)
            }
        }
    }
    
    private var createButton: some View {
        Button {
            print("Create \(selectedType.title)")
        } label: {
            Text("Create \(selectedType.title)")
                .font(.system(size: 17, weight: .semibold))
                .frame(maxWidth: .infinity)
                .frame(height: 54)
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
        .padding(.bottom, 12)
    }
    
}
