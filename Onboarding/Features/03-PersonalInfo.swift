import ComposableArchitecture
import SwiftUI

struct PersonalInfo: Reducer {
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

struct PersonalInfoView: View {
  let store: StoreOf<PersonalInfo>
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      Form {
        Button("Dismiss") {
          viewStore.send(.dismissButtonTapped)
        }
      }
      .navigationTitle("Personal Info")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          NavigationLink(
            "Next",
            state: AppReducer.Path.State.newPin()
          )
        }
      }
    }
  }
}

// MARK: - SwiftUI Previews

struct PersonalInfoView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      PersonalInfoView(store: Store(
        initialState: PersonalInfo.State(),
        reducer: PersonalInfo()
      ))
    }
  }
}
