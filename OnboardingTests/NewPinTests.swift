import XCTest
import ComposableArchitecture

@testable import Onboarding

@MainActor
final class NewPinTests: XCTestCase {
  func testNextButtonTappedSuccess() async {
    let store = TestStore(
      initialState: NewPin.State(
        pin: "1234"
      ),
      reducer: NewPin()
    )
    
    await store.send(.nextButtonTapped)
  }
}
