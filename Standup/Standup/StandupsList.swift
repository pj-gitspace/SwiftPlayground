//
//  StandupsList.swift
//  Standup
//
//  Created by Patrick Jarvis on 1/18/26.
//

import SwiftUI
import ComposableArchitecture

struct StandupsListFeature: Reducer {
    struct State {
        var standups: IdentifiedArrayOf<Standup> = []
    }
    enum Action {
        case addButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                state.standups.append(
                    Standup(id: UUID(), theme: .bubblegum)
                )
                return .none
            }
        }
    }
}

struct StandupsListView: View {
    let store: StoreOf<StandupsListFeature>
    var body: some View {
        WithViewStore(self.store, observe: \.standups) { viewStore in
            List {
                ForEach(viewStore.state) { standup in
                    StandupItemView(standup: standup)
                        .listRowBackground(standup.theme.mainColor)
                }
            }
            .navigationTitle("Daily Standups")
            .toolbar {
                ToolbarItem {
                    Button("Add") { viewStore.send(.addButtonTapped) }
                }
            }
        }
    }
}

struct StandupItemView: View {
    let standup: Standup
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(self.standup.title)
                .font(.headline)
            Spacer()
            HStack {
                Label("\(self.standup.attendees.count)", systemImage: "person.3")
                Spacer()
                Label(self.standup.duration.formatted(.units()), systemImage: "clock")
                    .labelStyle(.titleAndIcon)
            }
            .font(.caption)
        }
        .padding()
        .foregroundColor(.black)
    }
}

#Preview {
    NavigationStack {
        StandupsListView(store: Store(initialState: StandupsListFeature.State(standups: [.mock])) {
            StandupsListFeature()
        })
    }
}
