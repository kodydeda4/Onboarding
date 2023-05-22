import ComposableArchitecture
import SwiftUI

struct MainReducer: Reducer {
  struct State: Codable, Equatable, Hashable {
    let user: AuthClient.User
  }
  
  enum Action: Equatable {
    case signoutButtonTapped
    case dismissButtonTapped
  }
  
  @Dependency(\.dismiss) var dismiss
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
        
      case .signoutButtonTapped:
        return .none
        
      case .dismissButtonTapped:
        return .fireAndForget {
          await self.dismiss()
        }
      }
    }
  }
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
