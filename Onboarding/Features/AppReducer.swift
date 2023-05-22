import ComposableArchitecture
import SwiftUI

struct AppReducer: Reducer {
  enum State: Equatable {
    case onboarding(Onboarding.State = .init())
    case main(MainReducer.State)
  }
  
  enum Action: Equatable {
    case task
    case setState(State)
    case onboarding(Onboarding.Action)
    case main(MainReducer.Action)
  }
  
  @Dependency(\.userDefaults) var userDefaults
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
        
      case .task:
        return .run { send in
          for await userData in self.userDefaults.dataValues(forKey: "user") {
            if let user = userData.flatMap({ try? JSONDecoder().decode(UserDefaults.Dependency.User.self, from: $0) }) {
              await send(.setState(.main(.init(user: user))))
            } else {
              await send(.setState(.onboarding()))
            }
          }
        }
        
      case let .setState(value):
        state = value
        return .none
        
      case .onboarding, .main:
        return .none
      }
    }
    .ifCaseLet(/State.onboarding, action: /Action.onboarding) {
      Onboarding()
    }
    .ifCaseLet(/State.main, action: /Action.main) {
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
        then: OnboardingView.init
      )
      CaseLet(
        state: /AppReducer.State.main,
        action: AppReducer.Action.main,
        then: MainView.init
      )
    }
    .task { await ViewStore(store.stateless).send(.task).finish() }
  }
}

// MARK: - SwiftUI Previews

struct AppView_Previews: PreviewProvider {
  static var previews: some View {
    AppView(store: Store(
      initialState: .onboarding(),
      reducer: AppReducer()
    ))
  }
}
