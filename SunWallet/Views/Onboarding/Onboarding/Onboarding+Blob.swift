//
//  Blob.swift
//  TCOnboardingTemplate
//
//  Created by Jean-Marc Boullianne on 6/12/20.
//  Copyright © 2020 TrailingClosure. All rights reserved.
//

import Foundation
import SwiftUI

struct Blob: Shape {
    
    func path(in rect: CGRect) -> Path {
        
        let width: CGFloat = rect.width
        let height: CGFloat = rect.height
        
        let dW: CGFloat = 175
        let dH: CGFloat = 77
        
        let scaleX: CGFloat = width / dW
        let scaleY: CGFloat = height / dH
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 87.5, y: 0.5).scale(x: scaleX, y: scaleY))
        bezierPath.addCurve(to: CGPoint(x: 148.5, y: 76.5).scale(x: scaleX, y: scaleY), controlPoint1: CGPoint(x: 206.5, y: 1.5).scale(x: scaleX, y: scaleY), controlPoint2: CGPoint(x: 179.5, y: 70.5).scale(x: scaleX, y: scaleY))
        bezierPath.addCurve(to: CGPoint(x: 90.5, y: 46.5).scale(x: scaleX, y: scaleY), controlPoint1: CGPoint(x: 117.5, y: 82.5).scale(x: scaleX, y: scaleY), controlPoint2: CGPoint(x: 119.5, y: 46.5).scale(x: scaleX, y: scaleY))
        bezierPath.addCurve(to: CGPoint(x: 27.5, y: 64.5).scale(x: scaleX, y: scaleY), controlPoint1: CGPoint(x: 61.5, y: 46.5).scale(x: scaleX, y: scaleY), controlPoint2: CGPoint(x: 58.5, y: 70.5).scale(x: scaleX, y: scaleY))
        bezierPath.addCurve(to: CGPoint(x: 87.5, y: 0.5).scale(x: scaleX, y: scaleY), controlPoint1: CGPoint(x: -3.5, y: 58.5).scale(x: scaleX, y: scaleY), controlPoint2: CGPoint(x: -31.5, y: -0.5).scale(x: scaleX, y: scaleY))
        bezierPath.close()
        
        let path = Path(bezierPath.cgPath)
        return path
        
        // Width = 200
        // height = 140
        
        // P1 = (49, 116)
        // P2 = (101, 132)
        // P3 = (198, 160)
        // P4 = (140, 242)
        // P5 = (33, 234)
        // P6 = (1, 156)
    }
}

extension CGPoint {
    
    func scale(x: CGFloat, y: CGFloat) -> CGPoint {
        return CGPoint(x: self.x * x, y: self.y * y)
    }
}

struct Blob_Previews: PreviewProvider {
    static var previews: some View {
        Blob()
            .foregroundColor(Color.blue)
    }
}
