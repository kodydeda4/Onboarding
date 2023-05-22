import ComposableArchitecture
import SwiftUI

struct NewPin: Reducer {
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

struct NewPinView: View {
  let store: StoreOf<NewPin>
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      Form {
        Button("Dismiss") {
          viewStore.send(.dismissButtonTapped)
        }
      }
      .navigationTitle("New Pin")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          NavigationLink(
            "Next",
            state: AppReducer.Path.State.confirmNewPin()
          )
        }
      }
    }
  }
}

// MARK: - SwiftUI Previews

struct NewPinView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      NewPinView(store: Store(
        initialState: NewPin.State(),
        reducer: NewPin()
      ))
    }
  }
}
