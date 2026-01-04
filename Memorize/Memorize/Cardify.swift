//
//  Cardify.swift
//  Memorize
//
//  Created by Patrick Jarvis on 1/1/26.
//

import SwiftUI

struct Cardify: ViewModifier, Animatable {
    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
    }
    
    var isFaceUp: Bool {
        rotation < 90
    }
    
    var rotation: Double
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    func body(content: Content) -> some View {
        ZStack {
            let baseShape = RoundedRectangle(cornerRadius: Constants.cornerRadius)
            baseShape.strokeBorder(lineWidth: Constants.lineWidth).background(baseShape.fill(.white))
                .overlay(content)
                .opacity(isFaceUp ? 1 : 0)
            baseShape.fill().opacity(isFaceUp ? 0 : 1)
        }.rotation3DEffect(.degrees(rotation), axis: (0, -1, 0))
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
