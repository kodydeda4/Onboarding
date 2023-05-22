import XCTest
import ComposableArchitecture

@testable import Onboarding

@MainActor
final class MainReducerTests: XCTestCase {
  func testSignout() async {
    let store = TestStore(
      initialState: MainReducer.State(user: .init(
        id: .init(),
        email: .init(),
        password: .init(),
        firstName: .init(),
        lastName: .init(),
        telephoneNumber: .init(),
        pin: .init()
      )),
      reducer: MainReducer()
    ) {
      $0.userDefaults = .ephemeral()
    }
    await store.send(.signoutButtonTapped) {
      $0.alert = .signout
    }
    await store.send(.alert(.presented(.confirmSignoutButtonTapped))) {
      $0.alert = nil
    }
  }
}
