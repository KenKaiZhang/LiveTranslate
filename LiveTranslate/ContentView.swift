//
//  ContentView.swift
//  Live Translate
//
//  Created by Ken Zhang on 1/18/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var conversation: Conversation = Conversation(history: [])
    
    var body: some View {
        VStack {
            ConversationView(conversation: $conversation)
            Rectangle()
                .fill(Color(UIColor.lightGray))
                .frame(height: 1)
            RecordView(conversation: $conversation)
        }
    }
}

#Preview {
    ContentView()
}
