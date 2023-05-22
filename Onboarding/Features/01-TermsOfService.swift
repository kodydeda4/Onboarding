import ComposableArchitecture
import SwiftUI

struct TermsOfService: Reducer {
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
  
  struct TermsOfServiceView: View {
    let store: StoreOf<TermsOfService>
    
    var body: some View {
      WithViewStore(self.store, observe: { $0 }) { viewStore in
        Form {
          Button("Dismiss") {
            viewStore.send(.dismissButtonTapped)
          }
        }
        .navigationTitle("Terms Of Service")
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
            NavigationLink(
              "Next",
              state: AppReducer.Path.State.credentials()
            )
          }
        }
      }
    }
  }
  
  // MARK: - SwiftUI Previews
  
  struct TermsOfServiceView_Previews: PreviewProvider {
    static var previews: some View {
      NavigationStack {
        TermsOfServiceView(store: Store(
          initialState: TermsOfService.State(),
          reducer: TermsOfService()
        ))
      }
    }
  }
