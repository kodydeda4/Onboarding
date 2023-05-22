import XCTest
import ComposableArchitecture

@testable import Onboarding

@MainActor
final class AppReducerTests: XCTestCase {
  func testSetState() async {
    let onboarding = Onboarding.State()
    let main = MainReducer.State(user: .init(
      id: .init(),
      email: .init(),
      password: .init(),
      firstName: .init(),
      lastName: .init(),
      telephoneNumber: .init(),
      pin: .init()
    ))
    let store = TestStore(
      initialState: AppReducer.State.onboarding(.init()),
      reducer: AppReducer()
    ) {
      $0.userDefaults = .ephemeral()
    }
    await store.send(.setState(.onboarding(onboarding))) {
      $0 = .onboarding(onboarding)
    }
    await store.send(.setState(.main(main))) {
      $0 = .main(main)
    }
  }
}
