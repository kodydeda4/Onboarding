import ComposableArchitecture
import SwiftUI

///
/// Todo:
/// -[x] Switch between onboarding & main
/// -[ ] Add `Tagged` to AuthClient.User
/// -[ ] Add `@FocusState` to forms
/// -[ ] Add bonus points
/// -[ ] Use AsyncStream for value?
/// -[ ] Write tests
///

struct AppReducer: ReducerProtocol {
  struct State: Equatable {
    var isLoadingInitialState = true
    var destination: Destination
    
    enum Destination: Equatable {
      case onboarding(Onboarding.State)
      case main(MainReducer.State)
    }
  }
  
  enum Action: Equatable {
    case task
    case taskResponse(TaskResult<State.Destination>)
    case setDestination(State.Destination)
    case destination(Destination)
    
    enum Destination: Equatable {
      case onboarding(Onboarding.Action)
      case main(MainReducer.Action)
    }
  }
  
  @Dependency(\.auth) var auth
  
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
        state.isLoadingInitialState = true
        return .task {
          await .taskResponse(TaskResult {
            guard let user = try await self.auth.getUser() else {
              return .onboarding(Onboarding.State())
            }
            return .main(MainReducer.State(user: user))
          })
        }
        
      case let .taskResponse(.success(value)):
        state.isLoadingInitialState = false
        state.destination = value
        return .none
        
      case .taskResponse(.failure):
        state.isLoadingInitialState = false
        return .none
        
      case let .setDestination(value):
        state.destination = value
        return .none
        
      case let .destination(action):
        switch action {
        case .onboarding(.didComplete),
            .main(.didSignout):
          return .send(.task)
        default:
          return .none
        }
      }
    }
    ._printChanges()
  }
}

// MARK: - SwiftUI

struct AppView: View {
  let store: StoreOf<AppReducer>
  
  struct ViewState: Equatable {
    let isLoadingInitialState: Bool
    
    init(_ state: AppReducer.State) {
      self.isLoadingInitialState = state.isLoadingInitialState
    }
  }
  
  var body: some View {
    WithViewStore(store, observe: ViewState.init) { viewStore in
      if viewStore.isLoadingInitialState {
        VStack {}
          .task { await viewStore.send(.task).finish() }
      } else {
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
      }
    }
  }
}

// MARK: - SwiftUI Previews

struct AppView_Previews: PreviewProvider {
  static var previews: some View {
    AppView(store: Store(
      initialState: AppReducer.State(
        destination: .onboarding(.init())
      ),
      reducer: AppReducer()
    ))
  }
}
