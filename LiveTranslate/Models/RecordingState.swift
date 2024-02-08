//
//  RecordingState.swift
//  LiveTranslate
//
//  Created by Ken Zhang on 2/2/24.
//

import SwiftUI
import Foundation

enum RecordingState {
    case notRecording
    case recording1
    case recording2
    case recordingAuto
    
    var color: Color {
        switch self {
        case .recording1: return User.mainColor
        case .recording2: return User.secondaryColor
        case .recordingAuto: return hex2Color(hex: "#343434")
        default: return .gray
        }
    }
}

