import ComposableArchitecture
import SwiftUI

struct NewPin: Reducer {
  struct State: Codable, Equatable, Hashable {
    @BindingState var pin = String()
    
    var isNextButtonDisabled: Bool {
      pin.isEmpty
    }
  }
  
  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
  }
  
  var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      
      case .binding:
        return .none
        
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
        Section {
          TextField("Pin", text: viewStore.binding(\.$pin))
        }
      }
      .navigationTitle("New Pin")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          NavigationLink(
            "Next",
            state: Onboarding.Path.State.confirmPin(.init(pin: viewStore.pin))
          )
          .disabled(viewStore.isNextButtonDisabled)
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
