import SwiftUI
import ComposableArchitecture

@main
struct OnboardingApp: App {
  var body: some Scene {
    WindowGroup {
      AppView(store: Store(
        initialState: AppReducer.State(destination: .onboarding(.init())),
        reducer: AppReducer()
      ))
    }
  }
}
