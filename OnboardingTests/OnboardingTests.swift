import XCTest
import ComposableArchitecture

@testable import Onboarding

@MainActor
final class OnboardingTests: XCTestCase {
  func testOnboardingSuccess() async {
    let termsOfService = Onboarding.Path.State.termsOfService(.init(isAccepted: true))
    let credentials = Onboarding.Path.State.credentials(.init(email: "blob@example.com", password: "1234"))
    
    let store = TestStore(
      initialState: Onboarding.State(),
      reducer: Onboarding()
    ) {
      $0.userDefaults = .ephemeral()
    }
    await store.send(.path(.push(id: .init(integerLiteral: 0), state: termsOfService))) {
      $0.path = .init([
        termsOfService
      ])
    }
//    await store.send(.path(.push(id: .init(integerLiteral: 0), state: credentials))) {
//      $0.path = .init([
//        termsOfService,
//        credentials
//      ])
//    }
  }
}
