import ComposableArchitecture
import SwiftUI

struct PersonalInfo: Reducer {
  struct State: Codable, Equatable, Hashable {
    @BindingState var firstName = String()
    @BindingState var lastName = String()
    @BindingState var telephoneNumber = String()
    
    var isNextButtonDisabled: Bool {
      firstName.isEmpty || lastName.isEmpty || telephoneNumber.isEmpty
    }
  }
  
  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case nextButtonTapped
  }
    
  var body: some Reducer<State, Action> {
    BindingReducer()
  }
}

// MARK: - SwiftUI

struct PersonalInfoView: View {
  let store: StoreOf<PersonalInfo>
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      List {
        Section {
          HStack {
            Text("First Name").frame(width: 90, alignment: .leading)
            TextField("Johnny", text: viewStore.binding(\.$firstName))
              .textContentType(.givenName)
          }
          HStack {
            Text("Last Name").frame(width: 90, alignment: .leading)
            TextField("Appleseed", text: viewStore.binding(\.$lastName))
              .textContentType(.familyName)
          }
          HStack {
            Text("Telephone").frame(width: 90, alignment: .leading)
            TextField("123-456-7890", text: viewStore.binding(\.$telephoneNumber))
              .keyboardType(.phonePad)
              .textContentType(.telephoneNumber)
          }
        }
      }
      .listStyle(.grouped)
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
