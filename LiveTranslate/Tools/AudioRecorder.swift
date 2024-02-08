//
//  AudioRecorder.swift
//  LiveTranslate
//
//  Created by Ken Zhang on 2/2/24.
//

import Foundation
import Speech
import AVFoundation
import Accelerate

public class AudioRecorder: ObservableObject {
    
    private var audioEngine: AVAudioEngine!
    private var mixerNode: AVAudioMixerNode!
    private var recordURL = URL( fileURLWithPath: "recording.m4a",
                                 isDirectory: false,
                                 relativeTo: URL(fileURLWithPath: NSTemporaryDirectory()))
    
    private var silenceCount: Int = 0
    private let silenceThreshold: Float = -70.0 // dB, adjust based on testing
    
    private var isRecording: Bool = false
    
    @Published var flag: Bool = false
    
    init() {
        setupSession()
        setupEngine()
    }
    
    private func setupSession() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.record, mode: .measurement, options: .duckOthers)
        try? session.setActive(true, options: .notifyOthersOnDeactivation)
    }
    
    private func setupEngine() {
        audioEngine = AVAudioEngine()
        mixerNode = AVAudioMixerNode()
        
        // Attach the mixer node to the list of nodes in the engine
        mixerNode.volume = 0
        audioEngine.attach(mixerNode)
        
        // Constructing the audio processing graph
        // AVAudioInputNOde -> AVAudioMixerNode -> AVAudioMixerNode -> AVAudioOutpuNode
        let inputNode = audioEngine.inputNode
        let inputFormat = inputNode.outputFormat(forBus: 0)
        audioEngine.connect(inputNode, to: mixerNode, format: inputFormat)
        
        let mainMixerNode = audioEngine.mainMixerNode
        let mixerFormat = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: inputFormat.sampleRate, channels: 1, interleaved: false)
        audioEngine.connect(mixerNode, to: mainMixerNode, format: mixerFormat)
        
        audioEngine.prepare()
    }
    
    public func startRecording() throws {
        silenceCount = 0
        // The node we want the capture to be from
        let tapNode: AVAudioNode = mixerNode
        let format = tapNode.outputFormat(forBus: 0)
        
        let recordFile = try AVAudioFile(forWriting: recordURL, settings: format.settings)
        
        tapNode.installTap(onBus: 0, bufferSize: 4096, format: format) { (buffer, time) in
            self.detectSilence(in: buffer)
            if self.isRecording {
                try? recordFile.write(from: buffer)
            }
        }
        
        try audioEngine.start()
    }
    
    public func stopRecording() {
        isRecording = false
        mixerNode.removeTap(onBus: 0)
        audioEngine.stop()
    }
    
    private func detectSilence(in buffer: AVAudioPCMBuffer) {
        let power = calculatePower(buffer: buffer)
        if power < silenceThreshold {
            if isRecording {
                silenceCount += 1
                if silenceCount > 10 {
                    flag.toggle()
                }
            }
        } else {
            if !isRecording {
                print("WRITING TO BUFFER STARTS")
                isRecording = true
            }
            silenceCount = 0
        }
    }
    
    private func calculatePower(buffer: AVAudioPCMBuffer) -> Float {
        guard let floatChannelData = buffer.floatChannelData else {
            return 0.0
        }
        let channelDataValue = floatChannelData.pointee
        let channelDataValueAray = stride(from: 0, to: Int(buffer.frameLength), by: buffer.stride).map { channelDataValue[$0]}
        let sum: Float = (channelDataValueAray.map { return $0 * $0 }).reduce(0, +)
        let rms: Float = sqrt(sum) / Float(buffer.frameLength)
        
        let avgPower = 20 * log10(rms)
        return avgPower
    }
}
