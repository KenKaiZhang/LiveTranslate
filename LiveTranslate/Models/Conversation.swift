//
//  Conversation.swift
//  LiveTranslate
//
//  Created by Ken Zhang on 1/24/24.
//

import Foundation

struct Conversation {
    let id: UUID
    var timestamp: Date
    var history: [History]
    
    init(id: UUID = UUID(), timestamp: Date = Date(), history: [History]) {
        self.id = id
        self.timestamp = timestamp
        self.history = history
    }
}

extension Conversation {
    struct History: Identifiable, Hashable {
        let id: UUID
        var timestamp: Date
        var speaker: Speaker
        var native: String
        var translation: String
        
        init(id: UUID = UUID(), timestamp: Date = Date(), speaker: Speaker, native: String, translation: String) {
            self.id = id
            self.timestamp = timestamp
            self.speaker = speaker
            self.native = native
            self.translation = translation
        }
    }
}

extension Conversation {
    static var sampleConversation: Conversation = Conversation(
        history: [
            History(
                speaker: Speaker( name: "Alice", language: .english, main: true),
                native: "Hi Bob, how's everything going?",
                translation: "Hi Bob, how's everything going?"
            ),
            History(
                speaker: Speaker( name: "Bob", language: .english, main: false),
                native: "Hey Alice! Things are good. Busy, but good.",
                translation: "Hey Alice! Things are good. Busy, but good."
            ),
            History(
                speaker: Speaker( name: "Bob", language: .english, main: false),
                native: "Actually, I was thinking about trying that new hiking trail this weekend. Ever been?",
                translation: "Actually, I was thinking about trying that new hiking trail this weekend. Ever been?"
            ),
            History(
                speaker: Speaker( name: "Alice", language: .english, main: true),
                native: "No, I haven't been there yet. But I've heard great things about it.",
                translation: "No, I haven't been there yet. But I've heard great things about it."
            ),
            History(
                speaker: Speaker( name: "Alice", language: .english, main: true),
                native: "Speaking of outdoor activities, have you tried that new coffee shop downtown? Their patio is lovely.",
                translation: "Speaking of outdoor activities, have you tried that new coffee shop downtown? Their patio is lovely."
            ),
            History(
                speaker: Speaker( name: "Bob", language: .english, main: false),
                native: "Oh, I walked past it the other day. Looks nice. I'll have to give it a try. I've been looking for a new spot to get my morning coffee.",
                translation: "Oh, I walked past it the other day. Looks nice. I'll have to give it a try. I've been looking for a new spot to get my morning coffee."
            ),
            History(
                speaker: Speaker( name: "Alice", language: .english, main: true),
                native: "Their espresso is top-notch. Highly recommend it. Also, are you planning to go to Sara's get-together next weekend?",
                translation: "Their espresso is top-notch. Highly recommend it. Also, are you planning to go to Sara's get-together next weekend?"
            ),
            History(
                speaker: Speaker( name: "Bob", language: .english, main: false),
                native: "Yes, I am. I heard it's going to be a great crowd.",
                translation: "Yes, I am. I heard it's going to be a great crowd."
            ),
            History(
                speaker: Speaker( name: "Bob", language: .english, main: false),
                native: "I was thinking of bringing my famous lasagna. What do you think? That sounds perfect. Everyone loves your lasagna.",
                translation: "I was thinking of bringing my famous lasagna. What do you think? That sounds perfect. Everyone loves your lasagna."
            ),
            History(
                speaker: Speaker( name: "Alice", language: .english, main: true),
                native: "I might bake some of my chocolate chip cookies.",
                translation: "I might bake some of my chocolate chip cookies."
            ),
            History(
                speaker: Speaker( name: "Bob", language: .english, main: false),
                native: "Those are always a hit! Sara will be thrilled. By the way, I started a little garden project at home.",
                translation: "Those are always a hit! Sara will be thrilled. By the way, I started a little garden project at home."
            ),
            History(
                speaker: Speaker( name: "Alice", language: .english, main: true),
                native: "That’s interesting. What are you growing?",
                translation: "That’s interesting. What are you growing?"
            ),
            History(
                speaker: Speaker( name: "Alice", language: .english, main: true),
                native: "I've been thinking about starting a herb garden myself.",
                translation: "I've been thinking about starting a herb garden myself."
            ),
            History(
                speaker: Speaker( name: "Bob", language: .english, main: false),
                native: "I’ve got tomatoes, peppers, and a bunch of herbs. It’s quite rewarding.",
                translation: "I’ve got tomatoes, peppers, and a bunch of herbs. It’s quite rewarding."
            ),
            History(
                speaker: Speaker( name: "Bob", language: .english, main: false),
                native: "You should definitely start one. I can give you some tips if you like.",
                translation: "You should definitely start one. I can give you some tips if you like."
            ),
            History(
                speaker: Speaker( name: "Alice", language: .english, main: true),
                native: "I'd appreciate that. Maybe I can visit and see your garden?",
                translation: "I'd appreciate that. Maybe I can visit and see your garden?"
            ),
            History(
                speaker: Speaker( name: "Bob", language: .english, main: false),
                native: "Absolutely! Come by anytime.",
                translation: "Absolutely! Come by anytime."
            ),
            History(
                speaker: Speaker( name: "Bob", language: .english, main: false),
                native: "And you mentioned a pottery class? How's that going?",
                translation: "And you mentioned a pottery class? How's that going?"
            ),
            History(
                speaker: Speaker( name: "Alice", language: .english, main: true),
                native: "It's fantastic. Very relaxing. I just finished making a vase.",
                translation: "It's fantastic. Very relaxing. I just finished making a vase."
            ),
            History(
                speaker: Speaker( name: "Alice", language: .english, main: true),
                native: "You should join in one of these days. It's a lot of fun.",
                translation: "You should join in one of these days. It's a lot of fun."
            ),
            History(
                speaker: Speaker( name: "Bob", language: .english, main: false),
                native: "Pottery, huh? Might be interesting. I'll think about it. Alright, I've got to run. Let's catch up again soon, okay?",
                translation: "Pottery, huh? Might be interesting. I'll think about it. Alright, I've got to run. Let's catch up again soon, okay?"
            ),
            History(
                speaker: Speaker( name: "Alice", language: .english, main: true),
                native: "Sure thing. Have a great day, Bob!",
                translation: "Sure thing. Have a great day, Bob!"
            )
        ]
    )
    static var sampleShortConversation: Conversation = Conversation(
        history: [
            History(
                speaker: Speaker( name: "Alice", language: .english, main: true),
                native: "Hi Bob, how's everything going?",
                translation: "Hi Bob, how's everything going?"
            ),
            History(
                speaker: Speaker( name: "Bob", language: .english, main: false),
                native: "Hey Alice! Things are good. Busy, but good.",
                translation: "Hey Alice! Things are good. Busy, but good."
            ),
            History(
                speaker: Speaker( name: "Bob", language: .english, main: false),
                native: "Actually, I was thinking about trying that new hiking trail this weekend. Ever been?",
                translation: "Actually, I was thinking about trying that new hiking trail this weekend. Ever been?"
            ),
        ]
    )
}
