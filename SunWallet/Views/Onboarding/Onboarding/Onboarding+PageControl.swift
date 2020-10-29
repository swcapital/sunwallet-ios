//
//  PageControl.swift
//  TCOnboardingTemplate
//
//  Created by Jean-Marc Boullianne on 6/12/20.
//  Copyright © 2020 TrailingClosure. All rights reserved.
//

import SwiftUI

struct PageControl: View {
    
    var index: Int
    var count: Int
    var color: Color
    
    var body: some View {
        HStack(alignment: .center, spacing: 25) {
            ForEach(0..<self.count) { i in
                self.color
                    .opacity(self.index == i ? 1.0 : 0.2)
                    .frame(width: 10, height: 10, alignment: .center)
                    .cornerRadius(5)
            }
        }
    }
}

struct PageControl_Previews: PreviewProvider {
    static var previews: some View {
        PageControl(index: 0, count: 3, color: Color.black)
    }
}
