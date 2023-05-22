import ComposableArchitecture
import SwiftUI

struct Credentials: Reducer {
  struct State: Equatable {
    @BindingState var email = String()
    @BindingState var password = String()
    @PresentationState var alert: AlertState<Action.Alert>?
    
    var isNextButtonDisabled: Bool {
      email.isEmpty || password.isEmpty
    }
  }
  
  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case nextButtonTapped
    case presentAlert
    case didComplete
    case alert(PresentationAction<Alert>)
    
    enum Alert: Equatable {}
  }
    
  var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      
      case .nextButtonTapped:
        return .send(state.email.isValidEmail ? .didComplete : .presentAlert)
        
      case .presentAlert:
        state.alert = .invalidEmail
        return .none
        
      default:
        return .none
      }
    }
    .ifLet(\.$alert, action: /Action.alert)
  }
}

extension AlertState where Action == Credentials.Action.Alert {
  static let invalidEmail = Self {
    TextState("Please enter a valid email")
  }
}

private extension String {
  var isValidEmail: Bool {
    NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
      .evaluate(with: self)
  }
}

// MARK: - SwiftUI

struct CredentialsView: View {
  let store: StoreOf<Credentials>
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      List {
        Section {
          HStack {
            Text("Email").frame(width: 90, alignment: .leading)
            TextField("Required", text: viewStore.binding(\.$email))
              .textContentType(.emailAddress)
              .keyboardType(.emailAddress)
          }
          HStack {
            Text("Password").frame(width: 90, alignment: .leading)
            SecureField("Required", text: viewStore.binding(\.$password))
              .textContentType(.newPassword)
          }
        }
      }
      .listStyle(.grouped)
      .navigationTitle("Credentials")
      .alert(store: self.store.scope(
        state: \.$alert,
        action: Credentials.Action.alert
      ))
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
