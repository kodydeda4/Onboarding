import XCTest
import ComposableArchitecture

@testable import Onboarding

@MainActor
final class PersonalInfoTests: XCTestCase {
  func testNextButtonTappedSuccess() async {
    let store = TestStore(
      initialState: PersonalInfo.State(
        firstName: "Johnny",
        lastName: "Appleseed",
        telephoneNumber: "123-456-7890"
      ),
      reducer: PersonalInfo()
    )
    
    await store.send(.nextButtonTapped)
  }
}
