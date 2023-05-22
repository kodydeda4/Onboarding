import Dependencies
import Foundation

struct AuthClient: DependencyKey {
  var getUser: @Sendable () async throws -> User?
  var setUser: @Sendable (User) async throws -> Void
  
  struct Failure: Equatable, Error {}
  
  struct User: Codable, Equatable, Hashable, Identifiable {
    let id: UUID
    let firstName: String
    let lastName: String
    let email: String
    let pin: String
  }
}

extension DependencyValues {
  var auth: AuthClient {
    get { self[AuthClient.self] }
    set { self[AuthClient.self] = newValue }
  }
}

// MARK: - Implementations

extension AuthClient {
  static var liveValue = Self.init(getUser: { .mock }, setUser: { _ in })
  static var previewValue = Self.init(getUser: { .mock }, setUser: { _ in })
  static var testValue = Self.init(getUser: { .mock }, setUser: { _ in })
}

extension AuthClient.User {
  static let mock = Self(
    id: .init(),
    firstName: "Blob",
    lastName: "Jr",
    email: "blob@pointfree.co",
    pin: "1234"
  )
}
