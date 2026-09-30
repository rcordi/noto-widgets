import SwiftUI

struct ContentView: View {
    @State private var isLaunching = true

    var body: some View {
        ZStack {
            if isLaunching {
                LaunchView()
                    .transition(.opacity)
            } else {
                WidgetLibraryView()
                    .transition(.opacity)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                withAnimation(.easeOut(duration: 0.25)) {
                    isLaunching = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
