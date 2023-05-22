import ComposableArchitecture
import SwiftUI

///
/// Todo:
/// -[x] Switch between onboarding & main
/// -[X] Add `Tagged` to AuthClient.User
/// -[X] AppIcon
/// -[X] Persist data
/// -[ ] Add `@FocusState` to forms
/// -[ ] Add bonus points
/// -[X] Use AsyncStream for value
/// -[ ] Write tests
///

struct AppReducer: ReducerProtocol {
  struct State: Equatable {
    var destination = Destination.onboarding(.init())
    
    enum Destination: Equatable {
      case onboarding(Onboarding.State)
      case main(MainReducer.State)
    }
  }
  
  enum Action: Equatable {
    case task
    case setDestination(State.Destination)
    case destination(Destination)
    
    enum Destination: Equatable {
      case onboarding(Onboarding.Action)
      case main(MainReducer.Action)
    }
  }
  
  @Dependency(\.userDefaults) var userDefaults
  
  var body: some ReducerProtocolOf<Self> {
    Scope(state: \.destination, action: /Action.destination) {
      EmptyReducer()
        .ifCaseLet(
          /State.Destination.onboarding,
           action: /Action.Destination.onboarding,
           then: Onboarding.init
        )
        .ifCaseLet(
          /State.Destination.main,
           action: /Action.Destination.main,
           then: MainReducer.init
        )
    }
    Reduce { state, action in
      switch action {
      case .task:
        return .run { send in
          for await userData in self.userDefaults.dataValues(forKey: "user") {
            if let userData = userData, let user = try? JSONDecoder().decode(UserDefaults.Dependency.User.self, from: userData) {
              await send(.setDestination(.main(MainReducer.State(user: user))))
            } else {
              await send(.setDestination(.onboarding(Onboarding.State())))
            }
          }
        }
        
      case let .setDestination(value):
        state.destination = value
        return .none
        
      case .destination:
        return .none
      }
    }
  }
}

// MARK: - SwiftUI

struct AppView: View {
  let store: StoreOf<AppReducer>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      SwitchStore(store.scope(
        state: \.destination,
        action: AppReducer.Action.destination
      )) {
        CaseLet(
          state: /AppReducer.State.Destination.onboarding,
          action: AppReducer.Action.Destination.onboarding,
          then: OnboardingView.init
        )
        CaseLet(
          state: /AppReducer.State.Destination.main,
          action: AppReducer.Action.Destination.main,
          then: MainView.init
        )
      }
      .task { await viewStore.send(.task).finish() }
    }
  }
}

// MARK: - SwiftUI Previews

struct AppView_Previews: PreviewProvider {
  static var previews: some View {
    AppView(store: Store(
      initialState: AppReducer.State(),
      reducer: AppReducer()
    ))
  }
}
