//
//  MemorizeGame.swift
//  Memorize
//
//  Created by Patrick Jarvis on 11/22/25.
//

import Foundation

struct MemoryGame<CardContent: Equatable> {
    private(set) var cards: Array<Card>
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = []
        for i in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(i)
            cards.append(Card(content: content, id: "#\(2*i)"))
            cards.append(Card(content: content, id: "#\(2*i + 1)"))
        }
    }
    
    var potentailFaceUpCardIndex: Int? {
        cards.indices.filter {
            index in
            cards[index].isFaceUp && !cards[index].isMatched
        }.only
    }
    var allIsMatched: Bool {
        cards.reduce(true) { (accumulator, card) in
            return accumulator && card.isMatched
            
        }
    }
    
    mutating func choose(card: Card) {
        if let chosenIndex = cards.firstIndex(where: {card.id == $0.id}) {
            if !cards[chosenIndex].isFaceUp && !cards[chosenIndex].isMatched {
                if let potentialIndex = potentailFaceUpCardIndex {
                    if cards[potentialIndex].content == cards[chosenIndex].content {
                        cards[potentialIndex].isMatched = true
                        cards[chosenIndex].isMatched = true
                    }

                } else {

                    for index in cards.indices {
                        cards[index].isFaceUp = false
                    }
                }
                cards[chosenIndex].isFaceUp = true
            }
        }
    }
    
    mutating func shuffle() {
        cards.shuffle()
        for var card in cards {
            card.isMatched = false
            card.isFaceUp = false
        }
    }
    
    struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
        var debugDescription: String {
            "\(id): \(content) \(isFaceUp ? "up" : "down")\(isMatched ? "Matched" : " ")"
        }
        
        let content: CardContent
        var isFaceUp = false
        var isMatched = false
        var id: String
    }
}

extension Array {
    var only: Element? {
        return count == 1 ? first : nil
    }
}
