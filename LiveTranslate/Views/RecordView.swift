//
//  RecordView.swift
//  Live Translate
//
//  Created by Ken Zhang on 1/19/24.
//

import SwiftUI

struct RecordView: View {
    
    @EnvironmentObject var user: User
    @Binding var conversation: Conversation
    
    @State private var language1: Language = .english
    @StateObject var recognizer1 = LiveSpeechRecognizer(language: .english)
    @State var speaker1: Speaker = Speaker(name: "YOU", language: .english, main: true)
    
    @State private var language2: Language = .chinese
    @StateObject var recognizer2 = LiveSpeechRecognizer(language: .chinese)
    @State var speaker2: Speaker = Speaker(name: "OTHER", language: .chinese, main: false)

    @State var speakerPicker: Bool = true
    var speaker: Speaker { speakerPicker ? speaker1: speaker2 }
    var recognizer: LiveSpeechRecognizer { speakerPicker ? recognizer1 : recognizer2 }
    
    @StateObject var recorder = AudioRecorder()
    @State private var recording: RecordingState = .notRecording
    
    var body: some View {
        VStack {
            transcriptView()
            HStack {
                recordButton(selection: $language2, recordingState: .recording2)
                Spacer()
                autoRecordButton
                Spacer()
                recordButton(selection: $language1, recordingState: .recording1)
            }
            .padding(.horizontal)
        }
        .padding(.horizontal, 4)
        .onChange(of: recognizer.flag) {_, newState in if newState { restartRecording()} }
        .onChange(of: recorder.flag) {_, newState in if newState { restartRecording() } }
        .onChange(of: language1) {_, new in
            toggleRecording(newState: .notRecording)
            print("NEW LANGUAGE1 \(language1)")
            recognizer1.updateRecognizer(language: language1)
            speaker1.language = language1
        }
        .onChange(of: language2) {_, new in
            toggleRecording(newState: .notRecording)
            print("NEW LANGUAGE2 \(language2)")
            recognizer1.updateRecognizer(language: language2)
            speaker2.language = language1
        }
    }
    
    private func transcriptView() -> some View{
        TranscriptView(
            transcript: recording == .recordingAuto 
            ? .constant("")
            : .constant(recording == .notRecording ? "" : recognizer.transcript),
            
            placeholder: recording == .recordingAuto
            ? "Auto recording on"
            : (recording != .notRecording ? "Listening for sound..." : ""),
            
            main: .constant( speaker.main)
        )
            .padding(.horizontal)
    }
    
    private func recordButton(selection: Binding<Language>, recordingState: RecordingState) -> some View {
        LanguagePickerView(selection: selection) {
            RecordButtonView(
                recording: .constant(recording == recordingState),
                color: hex2Color(hex:recordingState == .recording1 ? user.mainTheme.details.hex : user.secondaryTheme.details.hex)
            ) {
                speakerPicker = recordingState == .recording1
                toggleRecording(newState: recordingState)
            }
        }
    }
    
    private var autoRecordButton: some View {
        VStack {
            Text("Auto")
                .font(.system(size: 12))
                .padding()
            RecordButtonView(recording: .constant(recording == .recordingAuto), color: hex2Color(hex: "#343434")) {
                speakerPicker = true
                toggleRecording(newState: .recordingAuto)
            }
        }
    }
    
    private func startRecording() {
        do {
            if recording == .recordingAuto {
                try recorder.startRecording()
            } else {
                print("STARTING RECORDING FOR \(speaker.name)")
                try recognizer.startRecording()
            }
        } catch {
            print (error)
        }
    }
    
    private func stopRecording() {
        print("ALL RECORDING STOPPED")
        recognizer1.stopRecording()
        recognizer2.stopRecording()
        recorder.stopRecording()
    }
    
    private func restartRecording() {
        stopRecording()
        print("RESTARTING RECORDING")
        saveTranscription {
            startRecording()
        }
    }
    
    private func toggleRecording(newState: RecordingState) {
        stopRecording()
        recording = recording == newState ? .notRecording : newState
        print(recording)
        if recording != .notRecording {
            startRecording()
        }
    }
    
//  When pause in recording is detected, save the content in history
    private func saveTranscription(completion: @escaping() -> Void) {
        if recording == .recordingAuto {
            print("IS AUTO")
            recognizer1.transcribe() {
                print("RECOGNIZER1 TRANSCRIPTION DONE")
                recognizer2.transcribe() {
                    print("RECOGNIZER2 TRANSCRIPTION DONE")
                    speakerPicker = recognizer1.confidence >= recognizer2.confidence
                    saveToHistory()
                    completion()
                }
            }
        } else {
            saveToHistory()
            completion()
        }
    }
    
    private func saveToHistory() {
        if recognizer.transcript.count > 0 {
            let newHistory = Conversation.History(speaker: speaker, native: recognizer.transcript, translation: "")
            conversation.history.append(newHistory)
        }
    }
}
