//
//  FlyingNumberView.swift
//  Memorize
//
//  Created by Patrick Jarvis on 1/2/26.
//

import SwiftUI

struct FlyingNumberView: View {
    let number: Int
    
    @State private var offset: CGFloat = 0
    @State private var opacity: CGFloat = 1
    
    var body: some View {
        if number != 0 {
            Text(number, format: .number.sign(strategy: .always()))
                .font(.largeTitle)
                .foregroundColor(number > 0 ? .blue : .red)
                .shadow(color: .black, radius: 1.5, x: 1, y: 1)
                .offset(x: 0, y: offset)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1)) {
                        offset = number < 0 ? 200 : -200
                        opacity = 0
                    }
                }
                .onDisappear {
                    offset = 0
                    opacity = 1
                }
        }
    }
}

#Preview {
    FlyingNumberView(number: 4)
}
