import ComposableArchitecture
import SwiftUI

struct ConfirmPin: Reducer {
  struct State: Codable, Equatable, Hashable {
    let pin: String
    @BindingState var confirmPin = String()
    
    var isNextButtonDisabled: Bool {
      pin != confirmPin
    }
  }
  
  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case doneButtonTapped
    case saveUserResponse(TaskResult<String>)
    case didComplete
  }
  
  @Dependency(\.auth) var auth
  
  var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
        
      case .binding:
        return .none
        
      case .doneButtonTapped:
        return .task {
          await .saveUserResponse(TaskResult {
            try await self.auth.setUser(.init(
              id: .init(),
              firstName: "Kody",
              lastName: "Deda",
              email: "kodydeda4@gmail.com",
              pin: "1234"
            ))
            return "Success"
          })
        }
        
      case .saveUserResponse:
        return .send(.didComplete)
        
      case .didComplete:
        return .none
        
      }
    }
  }
}

// MARK: - SwiftUI

struct ConfirmPinView: View {
  let store: StoreOf<ConfirmPin>
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      Form {
        Section("Confirm Pin - \(viewStore.pin)") {
          TextField("Pin", text: viewStore.binding(\.$confirmPin))
        }
      }
      .navigationTitle("Confirm Pin")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Done") {
            viewStore.send(.doneButtonTapped)
          }
          .disabled(viewStore.isNextButtonDisabled)
        }
      }
    }
  }
}

// MARK: - SwiftUI Previews

struct ConfirmNewPinView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      ConfirmPinView(store: Store(
        initialState: ConfirmPin.State(
          pin: "1234"
        ),
        reducer: ConfirmPin()
      ))
    }
  }
}