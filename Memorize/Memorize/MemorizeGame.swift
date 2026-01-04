//
//  MemorizeGame.swift
//  Memorize
//
//  Created by Patrick Jarvis on 11/22/25.
//

import Foundation

struct MemoryGame<CardContent: Equatable> {
    private(set) var cards: Array<Card>
    
    private(set) var score: Int = 0
    
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
                        score = score + 2 + cards[chosenIndex].bonus + cards[potentialIndex].bonus
                    } else {
                        if cards[chosenIndex].hasBeenSeen {
                            score = score - 1
                        }
                        if cards[potentialIndex].hasBeenSeen {
                            score = score - 1
                        }
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
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
                
                if oldValue && !isFaceUp {
                    hasBeenSeen = true
                }
            }
        }
        var isMatched = false {
            didSet {
                if isMatched {
                    stopUsingBonusTime()
                }
            }
        }
        var hasBeenSeen = false
        var id: String
        
        var lastFaceUpDate: Date? // track of the datetime a card is currently face up (will subtract this from Date.now())
        var bonusTimeLimit: TimeInterval = 6 // constant for how long a card is considered to gain bonus
        var pastFaceUpTime: TimeInterval = 0 // stores how long a card was previously face up
        
        private mutating func startUsingBonusTime() {
            if isFaceUp && !isMatched && bonusPercentRemaining > 0 {
                if lastFaceUpDate == nil {
                    lastFaceUpDate = Date()
                }
            }
        }
        
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            lastFaceUpDate = nil
        }
        
        // total amount of points * percentage of max it took to make the bonus
        var bonus: Int {
            Int(bonusTimeLimit * bonusPercentRemaining)
        }
        
        var bonusPercentRemaining: Double {
            bonusTimeLimit > 0 ? max(0, bonusTimeLimit - faceUpTime)/bonusTimeLimit: 0
        }
        
        var faceUpTime: TimeInterval {
            if let lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
    }
}

extension Array {
    var only: Element? {
        return count == 1 ? first : nil
    }
}
