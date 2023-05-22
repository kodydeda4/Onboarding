import Dependencies

extension AuthClient {
  static var live: Self {
    actor Auth {
      var currentUser: User? = nil
      
      func setCurrentUser(to user: User?) {
        self.currentUser = user
      }
    }
    
    let auth = Auth()
    
    return Self(
      getUser: { await auth.currentUser },
      setUser: { await auth.setCurrentUser(to: $0) }
    )
  }
}


