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
<img width="225" src="https://github.com/kodydeda4/Onboarding/assets/45678211/f407e8a5-e8b3-42f4-884d-9c806a8031d4">
<img width="225" src="https://github.com/kodydeda4/Onboarding/assets/45678211/c961bafe-8f04-4fd9-a8cb-b42f51a35ce5">
<img width="225" src="https://github.com/kodydeda4/Onboarding/assets/45678211/bd84bd3b-03d1-4547-95ee-ef84d91d7a04">
<img width="225" src="https://github.com/kodydeda4/Onboarding/assets/45678211/2ac47f7d-afac-46ae-a3a9-89456dbfd3f6">
<img width="225" src="https://github.com/kodydeda4/Onboarding/assets/45678211/82e34d34-174a-445d-90f4-0ab1b6c83ae7">
<img width="225" src="https://github.com/kodydeda4/Onboarding/assets/45678211/b3dfa744-0a73-4335-bc03-0cacad6392a2">
<img width="225" src="https://github.com/kodydeda4/Onboarding/assets/45678211/dc6b0276-f111-478f-8206-3ae6cfd5ae9e">
<img width="225" src="https://github.com/kodydeda4/Onboarding/assets/45678211/8fa17acd-7e6a-4eca-9673-6448cfee97cf">
