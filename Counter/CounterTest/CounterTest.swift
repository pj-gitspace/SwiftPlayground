//
//  CounterTest.swift
//  CounterTest
//
//  Created by Patrick Jarvis on 1/18/26.
//

import XCTest
@testable import Counter
import ComposableArchitecture

@MainActor
final class CounterTest: XCTestCase {

    func testCounter() async {
        let clock = TestClock()
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.continuousClock = clock
        }
        
        await store.send(.incrementButtonTapped) {
            $0.count = 1
        }
    }
    
    func testTimer() async {
        let clock = TestClock()
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.continuousClock = clock
        }
        
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerOn = true
        }
        await clock.advance(by: .seconds(1))
        
        await store.receive(.timerTicked) {
            $0.count = 1
        }
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerOn = false
        }
    }
    
    func testGetFact() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.factFetcher.fetch = { "This is the returned count" }
        }
        
        await store.send(.getFactButtonTapped) {
            $0.isFactLoading = true
        }
        
        await store.receive(.factResponse("This is the returned count")) {
            $0.fact = "This is the returned count"
            $0.isFactLoading = false
        }
    }

}
