//
//  ColorPicker.swift
//  LiveTranslate
//
//  Created by Ken Zhang on 2/7/24.
//

import SwiftUI

struct ThemePickerView: View {
    
    @EnvironmentObject var user: User
    @Binding var main: Bool
    
    private var colors: [[Theme]] {
        let allColors = Theme.allCases
        return stride(from: 0, to: allColors.count, by: 4).map {
            Array(allColors[$0..<min($0 + 4, allColors.count)])
        }
    }
    
    var body: some View {
        VStack {
            Text("Solid")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 60)
                .fontWeight(.bold)
            ForEach(0..<colors.count, id: \.self) { row in
                HStack {
                    ForEach(0..<colors[row].count, id: \.self) { col in
                        Button (action: {
                            if main {
                                user.mainTheme = colors[row][col]
                                print(user.mainTheme.details.name)
                            } else {
                                user.secondaryTheme = colors[row][col]
                            }
                        }) {
                            Circle()
                                .fill(hex2Color(hex: colors[row][col].details.hex))
                                .frame(width: 60, height: 60, alignment: .leading)
                                .padding(4)
                        }

                    }
                }
            }
        }

    }
}

#Preview {
    ThemePickerView(main: .constant(true))
}
