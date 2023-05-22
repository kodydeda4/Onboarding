import ComposableArchitecture
import SwiftUI

struct MainReducer: Reducer {
  struct State: Equatable {
    let user: UserDefaults.Dependency.User
    @PresentationState var alert: AlertState<Action.Alert>?
  }
  
  enum Action: Equatable {
    case signoutButtonTapped
    case alert(PresentationAction<Alert>)
    
    enum Alert: Equatable {
      case confirmSignoutButtonTapped
    }
  }
  
  @Dependency(\.userDefaults) var userDefaults
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
        
      case .signoutButtonTapped:
        state.alert = .signout
        return .none
        
      case .alert(.presented(.confirmSignoutButtonTapped)):
        return .run { _ in 
          self.userDefaults.set(Optional<Data>(nil), forKey: "user")
        }
        
      case .alert:
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
        List {
          Section("👋 Welcome Back") {
            Text("\(viewStore.user.firstName) \(viewStore.user.lastName)")
              .bold()
            Text(viewStore.user.email)
            Text(viewStore.user.id.description)
              .font(.caption)
              .foregroundStyle(.secondary)
          }
        }
        .navigationTitle("Main")
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
          email: "blob@pointfree.co",
          password: "1234",
          firstName: "Blob",
          lastName: "Jr",
          pin: "1234"
        )
      ),
      reducer: MainReducer()
    ))
  }
}
