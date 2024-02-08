//
//  TranscriptView.swift
//  LiveTranslate
//
//  Created by Ken Zhang on 1/25/24.
//

import SwiftUI

struct TranscriptView: View {
    
    @Binding var transcript: String
    var placeholder: String
    @Binding var main: Bool
    
    var speaking: Bool { !transcript.isEmpty }
    
    var body: some View {
        Text(speaking ? transcript : placeholder)
            .padding()
            .frame(maxWidth: .infinity, minHeight: 100, alignment: .topLeading)
            .foregroundColor(speaking ? Color(UIColor.darkGray) : Color(UIColor.lightGray))
            .overlay(
                RoundedRectangle(cornerRadius: 5.0)
                    .stroke(hex2Color(hex: "#DEDEDE"), lineWidth: 1)
            )
    }
}

#Preview {
    TranscriptView(
        transcript: .constant(""),
        placeholder: "Listening for sound...",
        main: .constant(false)
    )
}
