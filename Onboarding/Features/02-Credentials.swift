import ComposableArchitecture
import SwiftUI

struct Credentials: Reducer {
  struct State: Codable, Equatable, Hashable {
    //...
  }
  
  enum Action: Equatable {
    case dismissButtonTapped
  }
  
  @Dependency(\.dismiss) var dismiss
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
        
      case .dismissButtonTapped:
        return .fireAndForget {
          await self.dismiss()
        }
      }
    }
  }
}

// MARK: - SwiftUI

struct CredentialsView: View {
  let store: StoreOf<Credentials>
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      Form {
        Button("Dismiss") {
          viewStore.send(.dismissButtonTapped)
        }
      }
      .navigationTitle("Credentials")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          NavigationLink(
            "Next",
            state: AppReducer.Path.State.personalInfo()
          )
        }
      }
    }
  }
}

// MARK: - SwiftUI Previews

struct CredentialsView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      CredentialsView(store: Store(
        initialState: Credentials.State(),
        reducer: Credentials()
      ))
    }
  }
}
