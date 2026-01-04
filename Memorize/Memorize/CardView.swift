//
//  CardView.swift
//  Memorize
//
//  Created by Patrick Jarvis on 1/1/26.
//

import SwiftUI

struct CardView: View {
    let card: MemoryGame<String>.Card
    
    init(_ card: MemoryGame<String>.Card) {
        self.card = card
    }
    
    var body: some View {
        TimelineView(.animation(minimumInterval: 1/10)) { timeline in
            if card.isFaceUp || !card.isMatched {
                Pie(endAngle: .degrees(card.bonusPercentRemaining * 360)).opacity(0.5).overlay(
                    cardText
                )
                .padding(Constants.inset)
                .cardify(isFaceUp: card.isFaceUp)
                .opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
                .transition(.scale)
            } else {
                Color.clear
            }
        }
    }
    
    var cardText: some View {
        Text(card.content).font(.system(size:Constants.FontSize.largest)).minimumScaleFactor(Constants.FontSize.scaleFactor)
            .aspectRatio(1, contentMode: .fit)
            .rotationEffect(.degrees(card.isMatched ? 360 : 0))
            .animation(.spin(duration: 1), value: card.isMatched)
    }
    
    private struct Constants {
        static let cornerRadius: CGFloat = 12
        static let lineWidth: CGFloat = 5
        static let inset: CGFloat = 5
        struct FontSize {
            static let largest: CGFloat = 600
            static let scaleFactor: CGFloat = 0.01
        }
    }
}

extension Animation {
    static func spin(duration: TimeInterval) -> Animation {
        .linear(duration: duration).repeatForever(autoreverses: false)
    }
}

#Preview {
    CardView(MemoryGame<String>.Card(content: "X", isFaceUp: true, id: "Test")).padding().foregroundColor(.green)
}
