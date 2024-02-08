//
//  RecordButton.swift
//  LiveTranslate
//
//  Created by Ken Zhang on 1/31/24.
//

import SwiftUI

struct RecordButtonView: View {
    @Binding var recording: Bool
    var color: Color
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: recording ? "square" : "mic.fill")
                .font(.title2)
                .frame(width: 50, height: 50)
                .foregroundColor(Color.white)
                .background(color)
                .clipShape(Circle())
                .shadow(color: hex2Color(hex: "#B5B5B5"), radius: 2, y: 4)
        }
    }
}

//#Preview {
//    @EnvironmentObject var user: User
//    RecordButtonView(
//        recording: .constant(true),
//        color: hex2Color(hex: user.mainTheme.details.hex), 
//        action: {})
//}
