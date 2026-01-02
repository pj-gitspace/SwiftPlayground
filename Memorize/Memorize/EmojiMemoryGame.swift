//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Patrick Jarvis on 11/22/25.
//

import SwiftUI

// ViewModel
class EmojiMemoryGame: ObservableObject {
    private static let emojis = ["🍏", "🍉", "🍋", "🍊", "🫐", "🍇"]
    @Published private var gameController = MemoryGame(numberOfPairsOfCards: 6) { index in
        if index < emojis.count {
            return emojis[index]
        } else {
            return "❌"
        }
    }
    private var currentTheme: String = "faces"
    
    var cards: Array<MemoryGame<String>.Card> {
        gameController.cards
    }
    
    var allIsMatched: Bool {
        gameController.allIsMatched
    }
    
    // MARK: - Intents
    
    func shuffle() {
        gameController.shuffle()
    }
    
    func choose(_  card: MemoryGame<String>.Card) {
        gameController.choose(card: card)
    }
    
    func changeTheme(newTheme: String) {
        currentTheme = newTheme
    }
}
