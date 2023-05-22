import ComposableArchitecture
import SwiftUI

struct ConfirmNewPin: Reducer {
  struct State: Codable, Equatable, Hashable {
    //...
  }
  
  enum Action: Equatable {
    case doneButtonTapped
    case dismissButtonTapped
  }
  
  @Dependency(\.dismiss) var dismiss
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
        
      case .doneButtonTapped:
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

struct ConfirmNewPinView: View {
  let store: StoreOf<ConfirmNewPin>
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      Form {
        Button("Dismiss") {
          viewStore.send(.dismissButtonTapped)
        }
      }
      .navigationTitle("Confirm New Pin")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Done") {
            viewStore.send(.doneButtonTapped)
          }
        }
      }
    }
  }
}

// MARK: - SwiftUI Previews

struct ConfirmNewPinView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      ConfirmNewPinView(store: Store(
        initialState: ConfirmNewPin.State(),
        reducer: ConfirmNewPin()
      ))
    }
  }
}
