//
//  LanguageManager.swift
//  LiveTranslate
//
//  Created by Ken Zhang on 2/4/24.
//

import Combine
import Foundation

class LanguageManager: ObservableObject {
    @Published var language: Language
    var recognizer: LiveSpeechRecognizer {
        didSet {
            subscribeToRecognizer()
        }
    }
    var speaker: Speaker {
        didSet {
            subscribeToSpeaker()
        }
    }
    
    init(language: Language, name: String, main: Bool) {
        self.language = language
        self.recognizer = LiveSpeechRecognizer(language: language)
        self.speaker = Speaker(name: name, language: language, main: main)
    }
    
    public func updateLanguage(language: Language) {
        self.language = language
        recognizer.updateRecognizer(language: language)
        speaker.language = language
    }
    
    private var recognizerSubscription: AnyCancellable?
    private var speakerSubscription: AnyCancellable?
    
    private func subscribeToRecognizer() {
        recognizerSubscription = recognizer.objectWillChange.sink(receiveValue: objectWillChange.send)
    }
    private func subscribeToSpeaker() {
        recognizerSubscription = recognizer.objectWillChange.sink(receiveValue: objectWillChange.send)
    }
}
