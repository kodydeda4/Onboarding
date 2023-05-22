import ComposableArchitecture
import SwiftUI

struct PersonalInfo: Reducer {
  struct State: Codable, Equatable, Hashable {
    @BindingState var firstName = String()
    @BindingState var lastName = String()
    @BindingState var phoneNumber = String()
    
    var isNextButtonDisabled: Bool {
      firstName.isEmpty || lastName.isEmpty || phoneNumber.isEmpty
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

struct PersonalInfoView: View {
  let store: StoreOf<PersonalInfo>
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      Form {
        Section {
          TextField("First Name", text: viewStore.binding(\.$firstName))
          TextField("Last Name", text: viewStore.binding(\.$lastName))
          TextField("Telephone #", text: viewStore.binding(\.$phoneNumber))
        }
      }
      .navigationTitle("Personal Info")
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

struct PersonalInfoViewView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      PersonalInfoView(store: Store(
        initialState: PersonalInfo.State(),
        reducer: PersonalInfo()
      ))
    }
  }
}
