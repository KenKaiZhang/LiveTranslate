//
//  File.swift
//  LiveTranslate
//
//  Created by Ken Zhang on 2/7/24.
//

import SwiftUI

enum Theme: String, CaseIterable, Identifiable, Codable {
    
    case ruby
    case azure
    case lime
    case gold
    case amber
    case violet
    case rose
    case aqua
    case raspberry
    case ash
 
    var details: (name: String, hex: String) {
        switch self {
        case .ruby: return ("Ruby", "#E0115F")
        case .azure: return ("Azure", "#007FFF")
        case .lime: return ("Lime", "#00FF00")
        case .gold: return ("Gold", "#FFD700")
        case .amber: return ("Amber", "#FFBF00")
        case .violet: return ("Violet", "#8F00FF")
        case .rose: return ("Rose", "#FF007F")
        case .aqua: return ("Aqua", "#00FFFF")
        case .raspberry: return ("Raspberry", "#E30B5D")
        case .ash: return ("Ash", "#B2BEB5")
        }
    }
    
    var accentColor: Color {
        switch self {
        case .lime, .gold, .amber, .aqua, .ash: return .black
        case  .ruby, .azure, .violet, .rose, .raspberry: return .white
        }
    }
    
    var id: String {
        self.rawValue
    }
}
