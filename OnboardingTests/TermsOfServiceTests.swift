import XCTest
import ComposableArchitecture

@testable import Onboarding

@MainActor
final class TermsOfServiceTests: XCTestCase {
  func testNextButtonTappedSuccess() async {
    let store = TestStore(
      initialState: TermsOfService.State(isAccepted: true),
      reducer: TermsOfService()
    )
    await store.send(.nextButtonTapped)
  }
}
