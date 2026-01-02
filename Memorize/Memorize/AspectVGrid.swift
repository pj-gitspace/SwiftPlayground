//
//  AspectVGrid.swift
//  Memorize
//
//  Created by Patrick Jarvis on 1/1/26.
//

import SwiftUI

struct AspectVGrid<Item: Identifiable, ItemView: View>: View{
    var items: [Item]
    var aspectRatio: Float = 1
    var content: (Item) -> ItemView
    
    var body: some View {
        GeometryReader {
            geometry in
            let cardSize = gridItemWidthThatFits(count: items.count,
                                                 size: geometry.size, aspectRatio: aspectRatio)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: cardSize), spacing: 0)], spacing: 0) {
                ForEach(items) { item in
                    content(item).aspectRatio(CGFloat(aspectRatio), contentMode: .fit).padding(4)
                }
            }
            .foregroundColor(.green)
        }
    }
    
    func gridItemWidthThatFits(count: Int, size: CGSize, aspectRatio: Float) -> CGFloat{
        let count = CGFloat(count)
        var columnCount = 1.0
        repeat {
            let cardWidth = Float((size.width) / columnCount)
            print(cardWidth)
            let cardHeight = cardWidth / aspectRatio
            
            let numOfRows = (count / columnCount).rounded(.up)
            if numOfRows * Double(cardHeight) < size.height {
                print(cardWidth)
                return CGFloat(((size.width) / columnCount).rounded(.down))
            }
            columnCount += 1.0
        } while columnCount < count
        return (size.width / count).rounded(.down)
    }
}
