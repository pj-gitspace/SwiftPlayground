//
//  ContentView.swift
//  Counter
//
//  Created by Patrick Jarvis on 1/17/26.
//

import SwiftUI
import ComposableArchitecture

struct FactResponse: Codable {
    let fact: String
    let length: Int
}

struct FactClient {
    var fetch: @Sendable (Int) async throws -> String
}
extension FactClient: DependencyKey {
    static let liveValue = Self { _ in
        let (data, _) = try await URLSession.shared.data(from: URL(string: "https://catfact.ninja/fact")!)
        let response = try JSONDecoder().decode(FactResponse.self, from: data)
        return response.fact
    }
}
extension DependencyValues {
    var factFetcher: FactClient {
        get { self[FactClient.self] }
        set { self[FactClient.self] = newValue }
    }
}

struct CounterFeature: Reducer {
    struct State: Equatable {
        var count = 0
        var fact: String?
        var isFactLoading: Bool = false
        var isTimerOn = false
    }
    enum Action: Equatable {
        case decrementButtonTapped
        case factResponse(String)
        case getFactButtonTapped
        case incrementButtonTapped
        case timerTicked
        case toggleTimerButtonTapped
    }
    private enum CancelID {
        case timer
    }
    @Dependency(\.continuousClock) var clock
    @Dependency(\.factFetcher) var factClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .decrementButtonTapped:
                state.count -= 1
                state.fact = nil
                return .none
            case let .factResponse(fact):
                state.fact = fact
                state.isFactLoading = false
                return .none
            case .getFactButtonTapped:
                state.fact = nil
                state.isFactLoading = true
                return .run { send in
                    try await send(.factResponse(self.factClient.fetch(0)))
                }
            case .incrementButtonTapped:
                state.count += 1
                state.fact = nil
                return .none
            case .timerTicked:
                state.count += 1
                return .none
            case .toggleTimerButtonTapped:
                state.isTimerOn.toggle()
                if state.isTimerOn {
                    return .run { send in
                        for await _ in self.clock.timer(interval: .seconds(1)) {
                            await send(.timerTicked)
                        }
                    }
                    .cancellable(id: CancelID.timer)
                } else {
                    return .cancel(id: CancelID.timer)
                }
            }
        }
    }
}

struct ContentView: View {
    let store: StoreOf<CounterFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form {
                Section {
                    Text("\(viewStore.count)")
                    Button("Decrement") {
                        viewStore.send(.decrementButtonTapped)
                    }
                    Button("Increment") {
                        viewStore.send(.incrementButtonTapped)
                    }
                }
                Section {
                    Button {
                        viewStore.send(.getFactButtonTapped)
                    } label: {
                        HStack {
                            Text("Get fact")
                            if viewStore.isFactLoading {
                                Spacer()
                                ProgressView()
                            }
                        }
                    }
                    if let fact = viewStore.fact {
                        Text("\(fact)")
                    }
                }
                Section {
                    if viewStore.isTimerOn {
                        Button("Stop timer") {
                            viewStore.send(.toggleTimerButtonTapped)
                        }
                    } else {
                        Button ("Start timer") {
                            viewStore.send(.toggleTimerButtonTapped)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView(
        store: Store(initialState: CounterFeature.State()) {
            CounterFeature()
                ._printChanges()
        }
    )
}
