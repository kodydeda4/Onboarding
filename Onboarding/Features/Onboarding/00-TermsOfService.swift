import ComposableArchitecture
import SwiftUI

struct TermsOfService: Reducer {
  struct State: Codable, Equatable, Hashable {
    @BindingState var isAccepted = false
    var isNextButtonDisabled: Bool { !isAccepted }
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

struct TermsOfServiceView: View {
  let store: StoreOf<TermsOfService>
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      Form {
        Section(
          "Terms of service are the legal agreements between a service provider and a person who wants to use that service. The person must agree to abide by the terms of service in order to use the offered service. Terms of service can also be merely a disclaimer, especially regarding the use of websites. Vague language and lengthy sentences used in the terms of use have brought concerns on customer privacy and raised public awareness in many ways."
        ) {
          Toggle("I accept", isOn: viewStore.binding(\.$isAccepted))
        }
      }
      .navigationTitle("Terms Of Service")
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
