import ComposableArchitecture
import SwiftUI
import DependenciesAdditions
import _AppStorageDependency

struct Onboarding: Reducer {
  struct State: Codable, Equatable, Hashable {
    var path = StackState<Path.State>()
    var user = UserDefaults.Dependency.User(
      id: .init(),
      email: String(),
      password: String(),
      firstName: String(),
      lastName: String(),
      pin: String()
    )
  }
  
  enum Action: Equatable {
    case path(StackAction<Path.State, Path.Action>)
    case saveUserResponse(TaskResult<String>)
    case didComplete
  }
  
//  @Dependency(\.auth) var auth
  @Dependency(\.userDefaults) var userDefaults

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
        
      case let .path(action):
        switch action {
                    
        case .element(id: _, action: .termsOfService(.nextButtonTapped)):
          state.path.append(.credentials())
          return .none
          
        case let .element(id: id, action: .credentials(.nextButtonTapped)):
          guard case let .some(.credentials(childState)) = state.path[id: id]
          else { return .none }
          state.user.email = childState.email
          state.user.password = childState.password
          state.path.append(.personalInfo())
          return .none
          
        case let .element(id: id, action: .personalInfo(.nextButtonTapped)):
          guard case let .some(.personalInfo(childState)) = state.path[id: id]
          else { return .none }
          state.user.firstName = childState.firstName
          state.user.lastName = childState.lastName
          state.path.append(.newPin())
          return .none

        case let .element(id: id, action: .newPin(.nextButtonTapped)):
          guard case let .some(.newPin(childState)) = state.path[id: id]
          else { return .none }
          state.path.append(.confirmPin(.init(pin: childState.pin)))
          return .none

        case .element(id: _, action: .confirmPin(.doneButtonTapped)):
          return .task { [user = state.user] in
            await .saveUserResponse(TaskResult {
              try self.userDefaults.set(JSONEncoder().encode(user), forKey: "user")
              return "Success"
            })
          }

        default:
          return .none
        }
        
      case .saveUserResponse(.success):
        return .send(.didComplete)

      case .saveUserResponse, .didComplete:
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
