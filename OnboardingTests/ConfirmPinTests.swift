import XCTest
import ComposableArchitecture

@testable import Onboarding

@MainActor
final class ConfirmNewPinTests: XCTestCase {
  func testNextButtonTappedSuccess() async {
    let store = TestStore(
      initialState: ConfirmPin.State(
        pin: "1234",
        confirmPin: "1234"
      ),
      reducer: ConfirmPin()
    )
    
    await store.send(.doneButtonTapped)
  }
}
