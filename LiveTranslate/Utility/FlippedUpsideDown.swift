//
//  File.swift
//  LiveTranslate
//
//  Created by Ken Zhang on 1/25/24.
//

import SwiftUI

// Flips the view upside down
struct FlippedUpsideDown: ViewModifier {
   func body(content: Content) -> some View {
    content
           .rotationEffect(.degrees(180))
           .scaleEffect(x: -1, y: 1, anchor: .center)
   }
}
extension View{
   func flippedUpsideDown() -> some View{
     self.modifier(FlippedUpsideDown())
   }
}
