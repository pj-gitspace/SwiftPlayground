//
//  StandupFormTests.swift
//  StandupUITests
//
//  Created by Patrick Jarvis on 1/19/26.
//

import XCTest
import ComposableArchitecture
@testable import Standup

@MainActor
final class StandupFormTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAddDeleteAttendee() async {
        let store = TestStore(
            initialState: StandupFormFeature.State(
                standup: Standup(
                    id: UUID(),
                    attendees: [
                        Attendee(id: UUID())
                    ]
                )
            )
        ) {
            StandupFormFeature()
        } withDependencies: {
            $0.uuid = .incrementing
        }
        
        await store.send(.addAttendeeButtonTapped) {
            $0.focus = .attendee(UUID(0))
            $0.standup.attendees.append(Attendee(id: UUID(0)))
        }
    }
}
