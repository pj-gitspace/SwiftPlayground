//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Patrick Jarvis on 11/4/25.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var gameController: EmojiMemoryGame
    
    let emojiThemes: [String:[String]] =
    ["faces": ["😃", "🤢", "🤫", "😡"],
     "animals": ["🐵", "🦊", "🐱", "🦁", "🐷"],
     "fruits": ["🍏", "🍉", "🍋", "🍊", "🫐", "🍇"]
    ]
    @State var selectedTheme: String = "faces"
    var body: some View {
        VStack {
            Text("Has won: " + (gameController.allIsMatched ? "Yes" : "No"))
            cardStack.animation(.default, value: gameController.cards).background(.red)
            Button("Shuffle") {
                gameController.shuffle()
            }
        }
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
            CardView(card).onTapGesture {
                gameController.choose(card)
            }
            .foregroundColor(.green)
        }
    }
}

#Preview {
    EmojiMemoryGameView(gameController: EmojiMemoryGame())
}

