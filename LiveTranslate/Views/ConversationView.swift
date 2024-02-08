//
//  ConversationView.swift
//  Live Translate
//
//  Created by Ken Zhang on 1/19/24.
//

import SwiftUI

struct ConversationView: View {
    @Binding var conversation: Conversation

    /*
     *  We call flippedUpsideDown() twice because on the first time flips all the text upside down
     *  by turning the them 180. The second will turn the entire view 180 reorienting the text to be
     *  facing. The flipping will give us the behavior we want where the list renders from the bottom,
     *  but it will cause the first item in conversation.history to be at the bottom. To resolve that
     *  we simply go through the list in reverse order.
     */
    
    var body: some View {
        List(conversation.history.reversed()) { history in
            TextBubbleView(
                native: history.native,
                translation: history.translation,
                main: history.speaker.main
            )
            .flippedUpsideDown()
            .frame(maxWidth: .infinity, alignment: history.speaker.main ?.trailing : .leading)
            .listRowSeparator(.hidden)
        }
        .listStyle(PlainListStyle())
        .flippedUpsideDown()
    }
}

#Preview {
    ConversationView(
        conversation: .constant(Conversation.sampleConversation)
    )
}
