import ComposableArchitecture
import SwiftUI

struct Welcome: Reducer {
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

struct WelcomeView: View {
  let store: StoreOf<Welcome>
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      Form {
        Button("Dismiss") {
          viewStore.send(.dismissButtonTapped)
        }
      }
      .navigationTitle("Welcome")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          NavigationLink(
            "Next",
            state: AppReducer.Path.State.termsOfService()
          )
        }
      }
    }
  }
}

// MARK: - SwiftUI Previews

struct WelcomeView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      WelcomeView(store: Store(
        initialState: Welcome.State(),
        reducer: Welcome()
      ))
    }
  }
}
