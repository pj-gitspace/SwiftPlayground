//
//  Test.swift
//  Counter
//
//  Created by Patrick Jarvis on 1/18/26.
//

import XCTest
import ComposableArchitecture

@MainActor
final class CounterTests: XCTestCase {
    func testCount() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        }
        
        await store.send(.incrementButtonTapped) {
            $0.count = 1
        }
    }
}
