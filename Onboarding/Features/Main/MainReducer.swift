import ComposableArchitecture
import SwiftUI

struct MainReducer: Reducer {
  struct State: Equatable {
    let user: AuthClient.User
    @PresentationState var alert: AlertState<Action.Alert>?
  }
  
  enum Action: Equatable {
    case signoutButtonTapped
    case signoutResponse(TaskResult<String>)
    case didSignout
    case alert(PresentationAction<Alert>)
    
    enum Alert: Equatable {
      case confirmSignoutButtonTapped
    }
  }
  
  @Dependency(\.auth) var auth
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
        
      case .signoutButtonTapped:
        state.alert = .signout
        return .none
        
      case .signoutResponse(.success):
        return .send(.didSignout)
        
      case .signoutResponse(.failure):
        return .none
        
      case .alert(.presented(.confirmSignoutButtonTapped)):
        return .task {
          await .signoutResponse(TaskResult {
            try await self.auth.setUser(nil)
            return "Success"
          })
        }
        
      case .alert:
        return .none
        
      case .didSignout:
        return .none
      }
    }
    .ifLet(\.$alert, action: /Action.alert)
  }
}

extension AlertState where Action == MainReducer.Action.Alert {
  static let signout = Self(
    title: { TextState("Are you sure?") },
    actions: {
      ButtonState(role: .cancel) {
        TextState("Cancel")
      }
      ButtonState(role: .destructive, action: .confirmSignoutButtonTapped) {
        TextState("Sign Out")
      }
    },
    message: { TextState("You'll have to sign in again.") }
  )
}

// MARK: - SwiftUI

struct MainView: View {
  let store: StoreOf<MainReducer>
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      NavigationStack {
        Form {
          Text("Welcome back")
        }
        .navigationTitle("\(viewStore.user.firstName) \(viewStore.user.lastName)")
        .toolbar {
          ToolbarItemGroup(placement: .navigationBarTrailing) {
            Button("Sign Out") {
              viewStore.send(.signoutButtonTapped)
            }
            .foregroundColor(.red)
          }
        }
      }
      .alert(store: self.store.scope(
        state: \.$alert,
        action: MainReducer.Action.alert
      ))
    }
  }
}

// MARK: - SwiftUI Previews

struct LoggedInView_Previews: PreviewProvider {
  static var previews: some View {
    MainView(store: Store(
      initialState: MainReducer.State(
        user: .init(
          id: .init(),
          firstName: "Blob",
          lastName: "Jr",
          email: "blob@pointfree.co",
          pin: "1234"
        )
      ),
      reducer: MainReducer()
    ))
  }
}
