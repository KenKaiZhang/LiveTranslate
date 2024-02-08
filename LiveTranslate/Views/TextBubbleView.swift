//
//  TextBubbleView.swift
//  LiveTranslate
//
//  Created by Ken Zhang on 1/22/24.
//

import SwiftUI

struct TextBubbleView: View {
    
    var native: String
    var translation: String
    var main: Bool
    
    var body: some View {
        VStack (alignment: .leading){
            Text(native)
                .padding(.bottom, 4)
                .opacity(0.5)
                .font(.system(size: 14))
            Text(translation)
        }
        .padding()
        .foregroundColor(.white)
        .background(Color(main ? User.mainColor : User.secondaryColor))
        .clipShape(Rectangle())
        .cornerRadius(10)
    }
}

#Preview {
    TextBubbleView(
        native: "The quick brown fox jumped over the really lazy dog.",
        translation: "The quick brown fox jumped over the really lazy dog.",
        main: false)
}
