import ComposableArchitecture
import SwiftUI

struct AppReducer: Reducer {
  struct State: Equatable {
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
      case welcome(Welcome.State = .init())
      case termsOfService(TermsOfService.State = .init())
      case credentials(Credentials.State = .init())
      case personalInfo(PersonalInfo.State = .init())
      case newPin(NewPin.State = .init())
      case confirmPin(ConfirmPin.State)
    }
    
    enum Action: Equatable {
      case welcome(Welcome.Action)
      case termsOfService(TermsOfService.Action)
      case credentials(Credentials.Action)
      case personalInfo(PersonalInfo.Action)
      case newPin(NewPin.Action)
      case confirmPin(ConfirmPin.Action)
    }
    
    var body: some Reducer<State, Action> {
      Scope(state: /State.welcome, action: /Action.welcome) {
        Welcome()
      }
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

struct AppView: View {
  let store: StoreOf<AppReducer>
  
  var body: some View {
    NavigationStackStore(
      self.store.scope(state: \.path, action: AppReducer.Action.path)
    ) {
      VStack {
        Text("No Content")
          .font(.title)
          .bold()
          .foregroundStyle(.secondary)
      }
      .navigationTitle("Onboarding")
    } destination: {
      switch $0 {
      case .welcome:
        CaseLet(
          state: /AppReducer.Path.State.welcome,
          action: AppReducer.Path.Action.welcome,
          then: WelcomeView.init(store:)
        )
      case .termsOfService:
        CaseLet(
          state: /AppReducer.Path.State.termsOfService,
          action: AppReducer.Path.Action.termsOfService,
          then: TermsOfServiceView.init(store:)
        )
      case .credentials:
        CaseLet(
          state: /AppReducer.Path.State.credentials,
          action: AppReducer.Path.Action.credentials,
          then: CredentialsView.init(store:)
        )
      case .personalInfo:
        CaseLet(
          state: /AppReducer.Path.State.personalInfo,
          action: AppReducer.Path.Action.personalInfo,
          then: PersonalInfoView.init(store:)
        )
      case .newPin:
        CaseLet(
          state: /AppReducer.Path.State.newPin,
          action: AppReducer.Path.Action.newPin,
          then: NewPinView.init(store:)
        )
      case .confirmPin:
        CaseLet(
          state: /AppReducer.Path.State.confirmPin,
          action: AppReducer.Path.Action.confirmPin,
          then: ConfirmPinView.init(store:)
        )
      }
    }
  }
}

// MARK: - SwiftUI Previews

struct AppView_Previews: PreviewProvider {
  static var previews: some View {
    AppView(
      store: Store(
        initialState: AppReducer.State(
          path: StackState([
            .welcome(Welcome.State())
          ])
        )
      ) {
        AppReducer()
      }
    )
  }
}
