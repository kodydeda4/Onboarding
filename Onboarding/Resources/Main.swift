import SwiftUI
import ComposableArchitecture

@main
struct OnboardingApp: App {
  var body: some Scene {
    WindowGroup {
      if !_XCTIsTesting {
        AppView(store: Store(
          initialState: .onboarding(),
          reducer: AppReducer()
        ))
      }
    }
  }
}
