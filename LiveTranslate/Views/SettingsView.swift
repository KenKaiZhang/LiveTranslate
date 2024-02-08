//
//  SettingsView.swift
//  LiveTranslate
//
//  Created by Ken Zhang on 2/1/24.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var showingSettings = false
    @State private var targetProperty = User.mainColor
    @State private var targetColor = "hello"
    
    var body: some View {
        Button(action: {showingSettings = true}) {
            Image(systemName: "gearshape.fill")
                .font(.title2)
                .frame(width: 45, height: 45)
                .foregroundColor(hex2Color(hex: "#DEDEDE"))
                .background(.white)
                .clipShape(Circle())
                .shadow(color: hex2Color(hex: "#B5B5B5"), radius: 2, y: 4)
        }
        .sheet(isPresented: $showingSettings) {
            NavigationView {
                HStack {
                    Picker("", selection: $targetProperty) {
                        Text("Main").tag(User.mainColor)
                        Text("Secondary").tag(User.secondaryColor)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button(action: {showingSettings = false}) {
                            Image(systemName: "xmark")
                                .font(.subheadline)
                                .foregroundColor(hex2Color(hex: "#DEDEDE"))
                        }
                    }
                }
                .pickerStyle(.palette)
                .padding()
            }
            
        }
    }
}

#Preview {
    SettingsView()
}
