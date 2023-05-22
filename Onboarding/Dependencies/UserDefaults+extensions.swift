import Foundation
import DependenciesAdditions
import Foundation
import Tagged

extension UserDefaults.Dependency {
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
