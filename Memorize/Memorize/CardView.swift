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
        Pie(endAngle: .degrees(240)).opacity(0.5).overlay(
            Text(card.content).font(.system(size:Constants.FontSize.largest)).minimumScaleFactor(Constants.FontSize.scaleFactor)
                .aspectRatio(1, contentMode: .fit)
        )
        .padding(Constants.inset)
        .cardify(isFaceUp: card.isFaceUp)
        .opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
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

#Preview {
    CardView(MemoryGame<String>.Card(content: "X", isFaceUp: true, id: "Test")).padding().foregroundColor(.green)
}
