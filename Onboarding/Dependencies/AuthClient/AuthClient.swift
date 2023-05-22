import Dependencies
import Foundation
import Tagged

struct AuthClient: DependencyKey {
  var getUser: @Sendable () async throws -> User?
  var setUser: @Sendable (User?) async throws -> Void
  
  struct Failure: Equatable, Error {}
  
  struct User: Codable, Equatable, Hashable, Identifiable {
    let id: ID
    var email: String
    var password: String
    var firstName: String
    var lastName: String
    var pin: String
    
    typealias ID = Tagged<Self, UUID>
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
  static var liveValue = Self.live
  static var previewValue = Self.live
  static var testValue = Self(
    getUser: unimplemented("\(Self.self).getUser"),
    setUser: unimplemented("\(Self.self).setUser")
  )
}

extension AuthClient.User {
  static let mock = Self(
    id: .init(),
    email: "blob@pointfree.co",
    password: "1234",
    firstName: "Blob",
    lastName: "Jr",
    pin: "1234"
  )
}
