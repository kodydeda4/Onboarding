import SwiftUI
import ComposableArchitecture

@main
struct OnboardingApp: App {
  var body: some Scene {
    WindowGroup {
      AppView(store: Store(
        initialState: AppReducer.State.onboarding(.init()),
        reducer: AppReducer()
      ))
    }
  }
}
