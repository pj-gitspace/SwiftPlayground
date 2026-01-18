//
//  CounterApp.swift
//  Counter
//
//  Created by Patrick Jarvis on 1/17/26.
//

import ComposableArchitecture
import SwiftUI

@main
struct CounterApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                store: Store(initialState: CounterFeature.State()) {
                    CounterFeature()
                }
            )
        }
    }
}
