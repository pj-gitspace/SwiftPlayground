//
//  Pie.swift
//  Memorize
//
//  Created by Patrick Jarvis on 1/1/26.
//

import SwiftUI
import CoreGraphics

struct Pie: Shape {
    var startAngle: Angle = .zero
    var clockwise = true
    let endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        let startAngle = startAngle - .degrees(90)
        let endAngle = endAngle - .degrees(90)
        let circleCenter = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width / 2, rect.height / 2)
        let startPoint = CGPoint(x: circleCenter.x + radius*cos(startAngle.radians), y: circleCenter.y + radius*sin(startAngle.radians))
        
        var p = Path()
        p.move(to: circleCenter)
        p.addLine(to: startPoint)
        p.addArc(center: circleCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: !clockwise) // clockwise is inverted in iOS
        p.addLine(to: circleCenter)
        
        
        return p
    }
    
    
}
