//
//  StandupForm.swift
//  Standup
//
//  Created by Patrick Jarvis on 1/19/26.
//

import SwiftUI
import ComposableArchitecture

struct StandupFormFeature: Reducer {
    @Dependency(\.uuid) var uuid
    
    struct State: Equatable {
        @BindingState var standup: Standup
        @BindingState var focus: Field?
        enum Field: Hashable {
            case attendee(Attendee.ID)
            case title
        }
        
        init(standup: Standup, focus: Field? = .title) {
            self.standup = standup
            self.focus = focus
            
            if (self.standup.attendees.isEmpty) {
                self.standup.attendees.append(Attendee(id: UUID()))
            }
        }
    }
    enum Action: BindableAction {
        case addAttendeeButtonTapped
        case binding(BindingAction<State>)
        case deleteAttendees(atOffsets: IndexSet)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
//            .onChange(of: \.standup.title) { oldTitle, newTitle in
//                // check how binding has changed
//            }
        Reduce { state, action in
            switch action {
                
            case .addAttendeeButtonTapped:
                let attendeeId = self.uuid()
                state.standup.attendees.append(Attendee(id: attendeeId))
                state.focus = .attendee(attendeeId)
                return .none
            case .binding(_):
                return .none
            case .deleteAttendees(atOffsets: let atOffsets):
                state.standup.attendees.remove(atOffsets: atOffsets)
                if state.standup.attendees.isEmpty {
                    state.standup.attendees.append(Attendee(id: self.uuid()))
                }
                
                guard let firstIndex = atOffsets.first else {
                    return .none
                }
                let index = min(firstIndex, state.standup.attendees.count - 1)
                state.focus = .attendee(state.standup.attendees[index].id)
                return .none
            }
        }
    }
}

struct StandupForm: View {
    let store: StoreOf<StandupFormFeature>
    @FocusState var focus: StandupFormFeature.State.Field?
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form {
                Section {
                    TextField("Title", text: viewStore.$standup.title)
                        .focused(self.$focus, equals: .title)
                    HStack {
                        Slider(value: viewStore.$standup.duration.minutes, in: 5...30, step: 1) {
                            Text("Length")
                        }
                        Spacer()
                        Text("\(viewStore.standup.duration.formatted(.units()))")
                    }
                    ThemePicker(selection: viewStore.$standup.theme)
                } header: {
                    Text("Standup Info")
                }
                Section {
                    ForEach(viewStore.$standup.attendees) { $attendee in
                        TextField("Name", text: $attendee.name)
                            .focused(self.$focus, equals: .attendee(attendee.id))
                    }
                    .onDelete { indices in
                        viewStore.send(.deleteAttendees(atOffsets: indices))
                    }
                    
                    Button("Add attendee") {
                        viewStore.send(.addAttendeeButtonTapped)
                    }
                } header: {
                    Text("Attendees")
                }
            }
            .bind(viewStore.$focus, to: self.$focus)
        }
    }
}

struct ThemePicker: View {
  @Binding var selection: Theme

  var body: some View {
    Picker("Theme", selection: self.$selection) {
      ForEach(Theme.allCases) { theme in
        ZStack {
          RoundedRectangle(cornerRadius: 4)
                .fill(Color.blue)
          Label(theme.name, systemImage: "paintpalette")
            .padding(4)
        }
        .foregroundColor(.blue)
        .fixedSize(horizontal: false, vertical: true)
        .tag(theme)
      }
    }
  }
}

extension Duration {
    fileprivate var minutes: Double {
        get { Double(self.components.seconds / 60) }
        set { self = .seconds(newValue * 60) }
    }
}

#Preview {
    NavigationStack {
        StandupForm(
            store: Store(initialState: StandupFormFeature.State(standup: .mock)) {
                StandupFormFeature()
            }
        )
    }
}
