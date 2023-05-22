import ComposableArchitecture
import SwiftUI

struct Credentials: Reducer {
  struct State: Codable, Equatable, Hashable {
    @BindingState var email = String()
    @BindingState var password = String()
    
    var isNextButtonDisabled: Bool {
      email.isEmpty || password.isEmpty
    }
  }
  
  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case nextButtonTapped
  }
  
  @Dependency(\.dismiss) var dismiss
  
  var body: some Reducer<State, Action> {
    BindingReducer()
  }
}

// MARK: - SwiftUI

struct CredentialsView: View {
  let store: StoreOf<Credentials>
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      Form {
        Section {
          TextField("Email", text: viewStore.binding(\.$email))
          SecureField("Password", text: viewStore.binding(\.$password))
        }
      }
      .navigationTitle("Credentials")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Next") {
            viewStore.send(.nextButtonTapped)
          }
          .disabled(viewStore.isNextButtonDisabled)
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
