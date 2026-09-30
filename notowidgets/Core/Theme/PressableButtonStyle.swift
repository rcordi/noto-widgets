//
//  PressableButtonStyle.swift
//  notowidgets
//
//  Created by Rachel Cordi on 2026-09-30.
//

import SwiftUI

struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.55 : 1)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}
