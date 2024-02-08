//
//  Options.swift
//  Live Translate
//
//  Created by Ken Zhang on 1/18/24.
//

import MLKit
import SwiftUI

enum Language: String, CaseIterable, Identifiable, Codable {
    
    case english
    case chinese
    case spanish
    case japanese
    case russian
    case korean
    
    var details: (name: String, codex: String, mlkitCodex: TranslateLanguage) {
        switch self {
        case .english: return ("English", "en", .english)
        case .chinese: return ("Chinese", "zh", .chinese)
        case .spanish: return ("Spanish", "es", .spanish)
        case .japanese: return ("Japanese", "ja", .japanese)
        case .russian: return ("Russian", "ru", .russian)
        case .korean: return ("Korean", "ko", .korean)
        }
    }
    
    var id: String {
        self.rawValue
    }
}
