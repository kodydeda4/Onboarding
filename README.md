# Onboarding

Swift demo showing how the new [TCA Navigation APIs](https://github.com/pointfreeco/swift-composable-architecture/tree/prerelease/1.0) like `NavigationStackStore`, `NavigationLinkStore`, etc can be used to build a small onboarding app.

## Dependencies
This demo makes use of `UserDefaults.Dependency` found in [swift-dependency-additions](https://github.com/tgrapperon/swift-dependencies-additions).  

## Features

1. AppReducer - streams a `User` model stored in UserDefaults - switches between `MainReducer` and `Onboarding`. 
2. MainReducer - displays user information and signout logic. 
3. Onboarding - makes use of `NavigationStackStore` API's to push and pop child features:
  * TermsOfService
  * Credentials
  * PersonalInfo
  * NewPin
  * ConfirmPin
 
 ## Screenshots
<img width="225" src="https://github.com/kodydeda4/Onboarding/assets/45678211/c85eb18d-1785-45d6-a3c5-e71627295f9c">
<img width="225" src="https://github.com/kodydeda4/Onboarding/assets/45678211/78bd18f2-49b4-4727-afb8-5a13ca6703f9">
<img width="225" src="https://github.com/kodydeda4/Onboarding/assets/45678211/65807465-0ed1-4d1f-a5f2-3998acdf07ab">
<img width="225" src="https://github.com/kodydeda4/Onboarding/assets/45678211/f63f6d4c-5337-4b60-a037-0fa10fee53b1">
<img width="225" src="https://github.com/kodydeda4/Onboarding/assets/45678211/c78b56f3-3047-4a65-a8f1-cdd629fe8567">
<img width="225" src="https://github.com/kodydeda4/Onboarding/assets/45678211/95366c40-1aa2-4860-9410-16c51843de78">

<img width="225" src="https://github.com/kodydeda4/Onboarding/assets/45678211/03ffa395-27c9-43be-b38e-456d6cabdeb9">
<img width="225" src="https://github.com/kodydeda4/Onboarding/assets/45678211/89da0f66-84fe-4df0-b9c3-6e5f8fc47871">
