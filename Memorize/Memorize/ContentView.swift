//
//  ContentView.swift
//  Memorize
//
//  Created by Patrick Jarvis on 11/4/25.
//

import SwiftUI

struct ContentView: View {
    let emojiThemes: [String:[String]] =
    ["faces": ["😃", "🤢", "🤫", "😡"],
     "animals": ["🐵", "🦊", "🐱", "🦁", "🐷"],
     "fruits": ["🍏", "🍉", "🍋", "🍊", "🫐", "🍇"]
    ]
    @State var selectedTheme: String = "faces"
    var body: some View {
        ScrollView{
            VStack {
                Text("Memorize!").font(.title)
                themeSelector.padding(5)
                cardStack
            }.padding()
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
        LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]) {
            let deck = (currentTheme + currentTheme).shuffled()
            ForEach(0..<deck.count, id: \.self) { index in
                CardView(content: deck[index], isFaceUp: false).aspectRatio(1, contentMode: .fit)
            }
        }
        .foregroundColor(.green)
        .padding()
    }
}

struct CardView: View {
    let content: String
    @State var isFaceUp: Bool = false
    
    var body: some View {
        ZStack {
            let baseShape = RoundedRectangle(cornerRadius: 12)
            Group {
                baseShape.foregroundColor(.white)
                baseShape.strokeBorder(lineWidth: 10)
                Text(content).font(.largeTitle)
            }
            baseShape.fill().opacity(isFaceUp ? 0 : 1)
        }
        .onTapGesture(perform: {
            isFaceUp.toggle()
        })
    }
}

#Preview {
    ContentView()
}

