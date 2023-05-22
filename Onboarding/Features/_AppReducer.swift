import ComposableArchitecture
import SwiftUI

///
/// Todo:
/// 1. Switch between logged in onboarding
/// 2. Add `Tagged` to AuthClient.User
/// 3. Add `@FocusState` to forms
/// 4. Add bonus points
/// 5. Write tests
///


struct AppReducer: Reducer {
  enum State: Codable, Equatable, Hashable {
    case onboarding(Onboarding.State)
    case main(MainReducer.State)
  }
  
  enum Action: Equatable {
    case onboarding(Onboarding.Action)
    case main(MainReducer.Action)
  }
  
  var body: some Reducer<State, Action> {
    Scope(state: /State.onboarding, action: /Action.onboarding) {
      Onboarding()
    }
    Scope(state: /State.main, action: /Action.main) {
      MainReducer()
    }
  }
}

// MARK: - SwiftUI

struct AppView: View {
  let store: StoreOf<AppReducer>
  
  var body: some View {
    SwitchStore(store) {
      CaseLet(
        state: /AppReducer.State.onboarding,
        action: AppReducer.Action.onboarding,
        then: OnboardingView.init(store:)
      )
      CaseLet(
        state: /AppReducer.State.main,
        action: AppReducer.Action.main,
        then: MainView.init(store:)
      )
    }
  }
}

// MARK: - SwiftUI Previews

struct AppView_Previews: PreviewProvider {
  static var previews: some View {
    AppView(store: Store(
      initialState: AppReducer.State.onboarding(.init()),
      reducer: AppReducer()
    ))
  }
}
