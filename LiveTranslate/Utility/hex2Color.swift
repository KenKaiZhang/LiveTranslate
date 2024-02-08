//
//  hex2Color.swift
//  LiveTranslate
//
//  Created by Ken Zhang on 1/31/24.
//

import SwiftUI

/*
    Function used to convert color represented in hex notation to 
    usable Color.
 */

func hex2Color(hex: String) -> Color {
    var formattedHex = hex
    if formattedHex.hasPrefix("#") {
        formattedHex.remove(at: formattedHex.startIndex)
    }
    var rgb: UInt64 = 0
    Scanner(string: formattedHex).scanHexInt64(&rgb)
    
    let red = Double((rgb >> 16) & 0xFF) / 255.0
    let green = Double((rgb >> 8) & 0xFF) / 255.0
    let blue = Double(rgb & 0xFF) / 255.0
    
    return Color(red: red, green: green, blue: blue)
}
