import ComposableArchitecture
import SwiftUI

struct Onboarding: Reducer {
  struct State: Codable, Equatable, Hashable {
    var path = StackState<Path.State>()
  }
  
  enum Action: Equatable {
    case path(StackAction<Path.State, Path.Action>)
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
        
      case .path:
        return .none
      }
    }
    .forEach(\.path, action: /Action.path) {
      Path()
    }
  }
  
  struct Path: Reducer {
    enum State: Codable, Equatable, Hashable {
      case termsOfService(TermsOfService.State = .init())
      case credentials(Credentials.State = .init())
      case personalInfo(PersonalInfo.State = .init())
      case newPin(NewPin.State = .init())
      case confirmPin(ConfirmPin.State)
    }
    
    enum Action: Equatable {
      case termsOfService(TermsOfService.Action)
      case credentials(Credentials.Action)
      case personalInfo(PersonalInfo.Action)
      case newPin(NewPin.Action)
      case confirmPin(ConfirmPin.Action)
    }
    
    var body: some Reducer<State, Action> {
      Scope(state: /State.termsOfService, action: /Action.termsOfService) {
        TermsOfService()
      }
      Scope(state: /State.credentials, action: /Action.credentials) {
        Credentials()
      }
      Scope(state: /State.personalInfo, action: /Action.personalInfo) {
        PersonalInfo()
      }
      Scope(state: /State.newPin, action: /Action.newPin) {
        NewPin()
      }
      Scope(state: /State.confirmPin, action: /Action.confirmPin) {
        ConfirmPin()
      }
    }
  }
}

// MARK: - SwiftUI

struct OnboardingView: View {
  let store: StoreOf<Onboarding>
  
  var body: some View {
    NavigationStackStore(
      self.store.scope(state: \.path, action: Onboarding.Action.path)
    ) {
      Form {
        Text("👋 Hello World")
      }
      .navigationTitle("Welcome")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          NavigationLink(
            "Next",
            state: Onboarding.Path.State.termsOfService()
          )
        }
      }
      .navigationTitle("Welcome")
    } destination: {
      switch $0 {
      case .termsOfService:
        CaseLet(
          state: /Onboarding.Path.State.termsOfService,
          action: Onboarding.Path.Action.termsOfService,
          then: TermsOfServiceView.init(store:)
        )
      case .credentials:
        CaseLet(
          state: /Onboarding.Path.State.credentials,
          action: Onboarding.Path.Action.credentials,
          then: CredentialsView.init(store:)
        )
      case .personalInfo:
        CaseLet(
          state: /Onboarding.Path.State.personalInfo,
          action: Onboarding.Path.Action.personalInfo,
          then: PersonalInfoView.init(store:)
        )
      case .newPin:
        CaseLet(
          state: /Onboarding.Path.State.newPin,
          action: Onboarding.Path.Action.newPin,
          then: NewPinView.init(store:)
        )
      case .confirmPin:
        CaseLet(
          state: /Onboarding.Path.State.confirmPin,
          action: Onboarding.Path.Action.confirmPin,
          then: ConfirmPinView.init(store:)
        )
      }
    }
  }
}

// MARK: - SwiftUI Previews

struct OnboardingView_Previews: PreviewProvider {
  static var previews: some View {
    OnboardingView(store: Store(
      initialState: Onboarding.State(),
      reducer: Onboarding()
    ))
  }
}
