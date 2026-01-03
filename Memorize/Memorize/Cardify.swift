//
//  Cardify.swift
//  Memorize
//
//  Created by Patrick Jarvis on 1/1/26.
//

import SwiftUI

struct Cardify: ViewModifier {
    let isFaceUp: Bool
    func body(content: Content) -> some View {
        ZStack {
            let baseShape = RoundedRectangle(cornerRadius: Constants.cornerRadius)
            baseShape.strokeBorder(lineWidth: Constants.lineWidth).background(baseShape.fill(.white))
                .overlay(content)
                .opacity(isFaceUp ? 1 : 0)
            baseShape.fill().opacity(isFaceUp ? 0 : 1)
        }
    }
    
    private struct Constants {
        static let cornerRadius: CGFloat = 12
        static let lineWidth: CGFloat = 5
    }
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        modifier(Cardify(isFaceUp: isFaceUp))
    }
}
