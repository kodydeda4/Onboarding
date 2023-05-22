import XCTest
import ComposableArchitecture

@testable import Onboarding

@MainActor
final class CredentialsTests: XCTestCase {
  func testNextButtonTappedSuccess() async {
    let store = TestStore(
      initialState: Credentials.State(
        email: "blob@example.com",
        password: "123"
      ),
      reducer: Credentials()
    )
    
    await store.send(.nextButtonTapped)
    await store.receive(.didComplete)
  }
  
  func testNextButtonTappedFailure() async {
    let store = TestStore(
      initialState: Credentials.State(
        email: "blob",
        password: "123"
      ),
      reducer: Credentials()
    )
    
    await store.send(.nextButtonTapped)
    await store.receive(.presentAlert) { $0.alert = .invalidEmail }
  }
}
