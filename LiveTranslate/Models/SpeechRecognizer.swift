//
//  SpeechRecognizer.swift
//  Live Translate
//
//  Created by Ken Zhang on 1/19/24.
//

import Foundation
import AVFoundation
import Speech
import SwiftUI

actor SpeechRecognizer: ObservableObject {
    enum RecognizerError: Error {
        case nilRecognizer
        case notAuthorizedToRecognize
        case notPermittedToRecord
        case recognizerIsUnavailable
        
        var message: String {
            switch self {
            case .nilRecognizer: return "Can't initialize speech recognizer"
            case .notAuthorizedToRecognize: return "Not authorized to recognize speech"
            case .notPermittedToRecord: return "Not permitted to record audio"
            case .recognizerIsUnavailable: return "Recognizer is unavailable"
            }
        }
    }
    
    // Saving the transcription is done on the main thread
    @MainActor var transcript: String = ""
    
    private var audioEngine: AVAudioEngine?
    private var request: SFSpeechRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private let recognizer: SFSpeechRecognizer?
    
    // Initianating a new recognizer to avoid repeat mic access request
    init() {
        recognizer = SFSpeechRecognizer()   // New instance of the Apple's Speech framework
        
        // guard: transfer flow of control of program under condition
        // if recognizer is not initialized, execute whats inside {}
        guard recognizer != nil else {
            transcribe(RecognizerError.nilRecognizer)
            return
        }
        
        // Task: perform asynchronous operations
        // Code in {} runs in a seperate task (multi-threading)
        Task {
            do {
                guard await SFSpeechRecognizer.hasAuthorizationToRecognize() else {
                    throw RecognizerError.notAuthorizedToRecognize
                }
                guard await AVAudioSession.sharedInstance().hasPermissionToRecord() else {
                    throw RecognizerError.notPermittedToRecord
                }
            } catch {
                transcribe(error)
            }
        }
    }
    
    // @MainActor: makes sure the code in {} runs on main thread
    // All of them are asynchronous thanks to Task
    // await tells Swift to block code until the function is done
    @MainActor func startTranscribing() {
        Task {
            await transcribe()
        }
    }
    
    @MainActor func resetTranscript() {
        Task {
            await transcribe()
        }
    }
    
    @MainActor func stopTranscribing() {
        Task {
            await reset()
        }
    }
    
    // Transcribes speech to text until stopTranscribing is called
    // Only available within the scope
    private func transcribe() {
        // Checks if recognizer is available and ready for use
        guard let recognizer, recognizer.isAvailable else {
            self.transcribe(RecognizerError.recognizerIsUnavailable)
            return
        }
        
        do {
            let (audioEngine, request) = try Self.prepareEngine()
            self.audioEngine = audioEngine
            self.request = request
            // Starts the recognizer task with the request and uses resultHandler to deal with the results
            // [weak self] makes sure self object is deallocated
            self.task = recognizer.recognitionTask(with: request, resultHandler: {[weak self] result, error in
                // It will use the audioEngine from prepareEngine and result & error from resultHandler
                self?.recognitionHandler(audioEngine: audioEngine, result: result, error: error)
            })

        } catch {
            self.reset()
            self.transcribe(error)
        }
    }
    
    private func reset() {
        task?.cancel()
        audioEngine?.stop()
        audioEngine?.inputNode.removeTap(onBus: 0)
        audioEngine = nil
        request = nil
        task = nil
    }
    
    private static func prepareEngine() throws -> (AVAudioEngine, SFSpeechAudioBufferRecognitionRequest) {
        // Engine used to process audio sugnals
        let audioEngine = AVAudioEngine()
        // Object used to make request to speech recognition API
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        
        // Intermediary between the app and the OS for audio
        let audioSession = AVAudioSession.sharedInstance()
        // Sets session for playback and recording, precise audio input, and lower other audio sources while recording
        try audioSession.setCategory(.playAndRecord, mode: .measurement, options: .duckOthers)
        // Allows notification to others when session is deactivated
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        // The audio engine input node
        let inputNode = audioEngine.inputNode
        
        // Gets the audio format
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        // Installs a tap (a way to monitor and capture audio data) on the audio input node to captrue the incoming audio in 1024 chunks
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) {(buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            // Appends them to speech recognition request
            request.append(buffer)
        }
        
        // Prepare audio engine to start
        audioEngine.prepare()
        // Start the audio engine
        try audioEngine.start()
        
        return (audioEngine, request)
    }
    
    // Nonisolated allows function to be safely accessed from any thread
    nonisolated private func recognitionHandler(audioEngine: AVAudioEngine, result: SFSpeechRecognitionResult?, error: Error?) {
        let receivedFinalResult = result?.isFinal ?? false
        let receivedError = error != nil
        
        // Stops the aduio engine if a complete phrase/sentence is received or tere is an error
        if receivedFinalResult || receivedError {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        
        // Gives transcribe the best result
        if let result {
            transcribe(result.bestTranscription.formattedString)
        }
    }
    
    // Handle successful transcriptions
    nonisolated private func transcribe(_ message: String) {
        Task { @MainActor in
            transcript = message
        }
    }
    
    // Handles any error or bad transcriptions
    nonisolated private func transcribe(_ error: Error) {
        var errorMessage = ""
        if let error = error as? RecognizerError {
            errorMessage += error.message
        } else {
            errorMessage += error.localizedDescription
        }
        Task {@MainActor [errorMessage] in
                transcript = "<< \(errorMessage) >>"
        }
    }
}

// Asks the user for permission to recognize speech
extension SFSpeechRecognizer {
    static func hasAuthorizationToRecognize() async -> Bool {
        await withCheckedContinuation { continuation in
            requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }
    }
}

// Asks the user for permission to record
extension AVAudioSession {
    func hasPermissionToRecord() async -> Bool {
        await withCheckedContinuation { continuation in
            requestRecordPermission { authorized in
                continuation.resume(returning: authorized)
            }
        }
    }
}

