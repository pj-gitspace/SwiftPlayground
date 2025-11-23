//
//  MemorizeGame.swift
//  Memorize
//
//  Created by Patrick Jarvis on 11/22/25.
//

import Foundation

struct MemoryGame<CardContent> {
    var cards: Array<Card>
    
    func choose(card: Card) {
        
    }
    
    struct Card {
        var content: CardContent
        var isFaceUp: Bool
        var isMatched: Bool
    }
}
