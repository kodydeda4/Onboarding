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
 
 
