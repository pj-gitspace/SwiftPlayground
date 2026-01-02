//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Patrick Jarvis on 11/4/25.
//

import SwiftUI

@main
struct MemorizeApp: App {
    var body: some Scene {
        @StateObject var game = EmojiMemoryGame()
        WindowGroup {
            EmojiMemoryGameView(gameController: game)
        }
    }
}
