//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Patrick Jarvis on 11/4/25.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    
    typealias Card = MemoryGame<String>.Card
    @ObservedObject var gameController: EmojiMemoryGame
    
    let emojiThemes: [String:[String]] =
    ["faces": ["😃", "🤢", "🤫", "😡"],
     "animals": ["🐵", "🦊", "🐱", "🦁", "🐷"],
     "fruits": ["🍏", "🍉", "🍋", "🍊", "🫐", "🍇"]
    ]
    
    
    @State var selectedTheme: String = "faces"
    @State private var dealt = Set<Card.ID>()
    @State private var lastScoreChange: (Int, causedByCardId: Card.ID) = (0, causedByCardId: "")
    
    @Namespace private var deckNamespace
    
    private let deckWidth: CGFloat = 50
    private let aspectRatio: CGFloat = 2/3
    
    
    var body: some View {
        VStack {
            HStack {
                winView
                Spacer()
                shuffleButton
                Spacer()
                score
            }.padding()
            cardStack
            undealtDeckView
        }
    }
    
    
    private var winView: some View {
        Text("Has won: " + (gameController.allIsMatched ? "Yes" : "No"))
    }
    
    private var score: some View {
        Text ("Score \(gameController.score)").animation(nil)
    }
    
    private var shuffleButton: some View {
        Button("Shuffle") {
            withAnimation {
                gameController.shuffle()
            }
        }.offset(x: -15)
    }
    
    
    var currentTheme: [String] {
        emojiThemes[selectedTheme] ?? []
    }
    
    var themeSelector: some View {
        HStack {
            Text("Change theme:").multilineTextAlignment(.leading)
            HStack {
                ForEach([String](emojiThemes.keys), id: \.self) {
                    theme in
                    let uppercase = theme.prefix(1).uppercased() + theme.dropFirst()
                    Button(action: {
                        selectedTheme = theme
                    }, label: {
                        Text(uppercase)
                    })
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)
                }
            }
            .fixedSize(horizontal: true, vertical: true)
        }
    }
    
    var cardStack: some View {
        AspectVGrid(items: gameController.cards, aspectRatio: 2/3) { card in
            if isDealt(card) {
                CardView(card)
                    .overlay(FlyingNumberView(number: scoreChange(causedBy: card)))
                    .zIndex(scoreChange(causedBy: card) != 0 ? 1 : 0)
                    .onTapGesture {
                        withAnimation {
                            let scoreBeforeChoosing = gameController.score
                            gameController.choose(card)
                            let scoreChange = gameController.score - scoreBeforeChoosing
                            lastScoreChange = (scoreChange, causedByCardId: card.id)
                        }
                    }
                    .matchedGeometryEffect(id: card.id, in: deckNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                    .foregroundColor(.green)
            }
        }
    }
    
    private var undealtDeckView: some View {
        ZStack {
            ForEach(undealtCards) {
                card in
                CardView(card)
                    .foregroundColor(.green)
                    .matchedGeometryEffect(id: card.id, in: deckNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
            .frame(width: deckWidth, height: deckWidth / aspectRatio)
        }
        .onTapGesture {
            var delay = 0.0
            for card in gameController.cards {
                withAnimation(.easeInOut(duration: 1).delay(delay)) {
                    _ = dealt.insert(card.id)
                }
                delay += 0.15
            }
        }
    }
    
    private func isDealt(_ card: Card) -> Bool {
        dealt.contains(card.id)
    }
    
    private var undealtCards: [Card] {
        gameController.cards.filter { !isDealt($0) }
    }
    
    private func scoreChange(causedBy card: Card) -> Int {
        let (amount, id) = lastScoreChange
        return card.id == id ? amount : 0
    }
}

#Preview {
    EmojiMemoryGameView(gameController: EmojiMemoryGame())
}

