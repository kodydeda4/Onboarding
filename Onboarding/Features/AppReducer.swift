import SwiftUI
import ComposableArchitecture

struct AppReducer: Reducer {
  struct State: Equatable {
    
  }
  enum Action: Equatable {
    
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
        
      }
    }
  }
}


struct AppView: View {
  let store: StoreOf<AppReducer>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      NavigationStack {
        Text("Hello World")
      }
    }
  }
}

struct AppView_Previews: PreviewProvider {
  static var previews: some View {
    AppView(store: Store(
      initialState: AppReducer.State(),
      reducer: AppReducer()
    ))
  }
}
