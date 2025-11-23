//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Patrick Jarvis on 11/22/25.
//

import SwiftUI

// ViewModel
class EmojiMemoryGame {
    var gameController: MemoryGame<String>
    
    init(controller: MemoryGame<String>) {
        gameController = controller
    }
}
