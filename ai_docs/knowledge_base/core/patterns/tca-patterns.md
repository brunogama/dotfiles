---
title: TCA Architecture Patterns
source_url: https://github.com/pointfreeco/swift-composable-architecture
last_fetched: '2025-01-12T15:00:00Z'
checksum: sha256:g6h7i8j9012345678901234567890abcdef1234567890abcdef789012
domains: [tca, architecture, state-management]
agent_refs: [frontend-developer, ios-architect, swift-pro]
---

<!-- file: patterns/tca-patterns.md -->

# TCA (The Composable Architecture) Patterns

Patterns and best practices for using The Composable Architecture in Swift applications.

<!-- section: reducer-basics -->

## Reducer Basics

### Basic Reducer Structure

```swift
import ComposableArchitecture

@Reducer
struct CounterFeature {
    @ObservableState
    struct State: Equatable {
        var count = 0
    }

    enum Action {
        case incrementButtonTapped
        case decrementButtonTapped
        case resetButtonTapped
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .incrementButtonTapped:
                state.count += 1
                return .none

            case .decrementButtonTapped:
                state.count -= 1
                return .none

            case .resetButtonTapped:
                state.count = 0
                return .none
            }
        }
    }
}
```

### View Integration

```swift
struct CounterView: View {
    @Bindable var store: StoreOf<CounterFeature>

    var body: some View {
        VStack {
            Text("\(store.count)")
                .font(.largeTitle)

            HStack {
                Button("-") { store.send(.decrementButtonTapped) }
                Button("Reset") { store.send(.resetButtonTapped) }
                Button("+") { store.send(.incrementButtonTapped) }
            }
        }
    }
}
```

<!-- endsection -->

<!-- section: composition-patterns -->

## Composition Patterns

### Parent-Child Composition

```swift
@Reducer
struct ParentFeature {
    @ObservableState
    struct State: Equatable {
        var child: ChildFeature.State = .init()
        var isChildPresented = false
    }

    enum Action {
        case child(ChildFeature.Action)
        case toggleChild
    }

    var body: some Reducer<State, Action> {
        Scope(state: \.child, action: \.child) {
            ChildFeature()
        }

        Reduce { state, action in
            switch action {
            case .child:
                return .none

            case .toggleChild:
                state.isChildPresented.toggle()
                return .none
            }
        }
    }
}
```

### Sibling Composition

```swift
@Reducer
struct AppFeature {
    @ObservableState
    struct State: Equatable {
        var tab1 = Tab1Feature.State()
        var tab2 = Tab2Feature.State()
        var selectedTab = 0
    }

    enum Action {
        case tab1(Tab1Feature.Action)
        case tab2(Tab2Feature.Action)
        case selectTab(Int)
    }
}
```

<!-- endsection -->

<!-- section: effects-patterns -->

## Effects and Dependencies

### Dependency Injection

```swift
struct APIClient: DependencyKey {
    var fetchUser: @Sendable (Int) async throws -> User

    static let liveValue = APIClient(
        fetchUser: { id in
            let url = URL(string: "https://api.example.com/users/\(id)")!
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode(User.self, from: data)
        }
    )

    static let testValue = APIClient(
        fetchUser: { _ in User(id: 1, name: "Test User") }
    )
}

extension DependencyValues {
    var apiClient: APIClient {
        get { self[APIClient.self] }
        set { self[APIClient.self] = newValue }
    }
}
```

### Using Effects

```swift
@Reducer
struct UserFeature {
    @ObservableState
    struct State: Equatable {
        var user: User?
        var isLoading = false
        var alert: AlertState<Action>?
    }

    @Dependency(\.apiClient) var apiClient

    enum Action {
        case loadUserTapped
        case userResponse(Result<User, Error>)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .loadUserTapped:
                state.isLoading = true
                return .run { send in
                    await send(.userResponse(
                        Result { try await apiClient.fetchUser(1) }
                    ))
                }

            case let .userResponse(.success(user)):
                state.isLoading = false
                state.user = user
                return .none

            case let .userResponse(.failure(error)):
                state.isLoading = false
                state.alert = AlertState(title: TextState(error.localizedDescription))
                return .none
            }
        }
    }
}
```

<!-- endsection -->

<!-- section: testing-patterns -->

## Testing Patterns

### Basic Test Structure

```swift
@MainActor
final class CounterFeatureTests: XCTestCase {
    func testIncrement() async {
        let store = TestStore(
            initialState: CounterFeature.State()
        ) {
            CounterFeature()
        }

        await store.send(.incrementButtonTapped) {
            $0.count = 1
        }

        await store.send(.incrementButtonTapped) {
            $0.count = 2
        }
    }
}
```

### Testing Effects

```swift
func testLoadUser() async {
    let store = TestStore(
        initialState: UserFeature.State()
    ) {
        UserFeature()
    } withDependencies: {
        $0.apiClient.fetchUser = { _ in
            User(id: 1, name: "Mock User")
        }
    }

    await store.send(.loadUserTapped) {
        $0.isLoading = true
    }

    await store.receive(.userResponse(.success(User(id: 1, name: "Mock User")))) {
        $0.isLoading = false
        $0.user = User(id: 1, name: "Mock User")
    }
}
```

<!-- endsection -->

<!-- endfile -->
