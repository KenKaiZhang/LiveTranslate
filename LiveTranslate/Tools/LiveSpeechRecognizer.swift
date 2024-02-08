//
//  File.swift
//  LiveTranslate
//
//  Created by Ken Zhang on 1/21/24.
//

import Foundation
import AVFoundation
import Speech
import SwiftUI

public class LiveSpeechRecognizer: ObservableObject  {

    // MARK: Properties
    private var audioEngine: AVAudioEngine!
    private var recognizer: SFSpeechRecognizer
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    
    private var timer: Timer?
    private var language: String
    
    @Published var transcript: String = ""
    @Published var confidence: Float = 0.0
    @Published var flag: Bool = false // Flag to view indicating speaker has stopped talking
    
    
    // Initialize a speech recognizer
    init(language: Language) {
        guard let recognizer = SFSpeechRecognizer(locale: Locale(identifier: language.details.codex)) else {
            fatalError("Speech recognizer unavailable for given locale.")
        }
        self.recognizer = recognizer
        self.language = language.details.name
        
        setupSession()
        setupEngine()
    }
    
    internal func updateRecognizer(language: Language) {
        guard let recognizer = SFSpeechRecognizer(locale: Locale(identifier: language.details.codex)) else {
            fatalError("Speech recognizer unavailable for given locale.")
        }
        self.recognizer = recognizer
        self.language = language.details.name
    }
    
    
    private func setupSession() {
        Task {
            guard await AVAudioSession.sharedInstance().hasPermissionToRecord() else {
                print("Permission to record speech was unauthorized.")
                return
            }
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try? audioSession.setActive(true, options: .notifyOthersOnDeactivation)
    }
    
    private func setupEngine() {
        self.audioEngine = AVAudioEngine()
    }
    
    // Start recording and recognizing speech
    public func startRecording() throws {
        transcript = ""
        flag = false
        
        resetTask()
        
        Task {
            guard await SFSpeechRecognizer.hasAuthorizationToRecognize() else {
                print("Permission to recognize speech was unauthorized.")
                return
            }
        }

        // Setting up the recognition request
        request = SFSpeechAudioBufferRecognitionRequest()
        guard let request = request else {
            fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object.")
        }
        request.shouldReportPartialResults = true
        task = recognizer.recognitionTask(with: request) {[weak self] result, error in
            guard let self = self else { return }
            
            var isFinal = false
            if let result = result {
                self.transcript = result.bestTranscription.formattedString
                print(self.transcript)
                isFinal = result.isFinal
            }
            if isFinal {
                self.stopRecording()
            } else if error == nil {
                self.restartSpeechTimer()
            }
        }

        // Setting up the input node to handle audio input

        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 4096, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.request?.append(buffer)
        }
        self.audioEngine.prepare()
        try audioEngine.start()
        print("\(language) AUDIO ENGINE HAS STARTED")
    }
    
    public func stopRecording() {
        resetTask()
        request = nil
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
    }

    private func resetTask() {
        task?.cancel()
        task = nil
    }
    
    // Stops the recognizer when silence is detected
    private func restartSpeechTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            flag.toggle()
            print("PAUSE DETECTED: \(flag)")
            timer = nil
        }
    }
    
    public func transcribe(completion: @escaping () -> Void) {
        transcript = ""
        let audioURL: URL = URL( fileURLWithPath: "recording.m4a",
                                 isDirectory: false,
                                 relativeTo: URL(fileURLWithPath: NSTemporaryDirectory()))
        let recordRequest = SFSpeechURLRecognitionRequest(url: audioURL)
        recordRequest.shouldReportPartialResults = false
        recognizer.recognitionTask(with: recordRequest) {[weak self] result, error in
            guard let self = self else {return}
            guard error == nil else {
                print(error!)
                completion()
                return
            }
            if let result = result {
                if result.isFinal {
                    let transcript = result.bestTranscription
                    self.transcript = transcript.formattedString
                    self.confidence = transcript.segments.reduce(0) { $0 + $1.confidence } / Float(transcript.segments.count)
                }
                completion()
            }
        }
    }
}

extension SFSpeechRecognizer {
    static func hasAuthorizationToRecognize() async -> Bool {
        await withCheckedContinuation { continuation in
            requestAuthorization{ status in
                continuation.resume(returning: status == .authorized)
            }
        }
    }
}

extension AVAudioSession {
    func hasPermissionToRecord() async -> Bool {
        await withCheckedContinuation { continuation in
            requestRecordPermission { authorized in
                continuation.resume(returning: authorized)
            }
        }
    }
}
