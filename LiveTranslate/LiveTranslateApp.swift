//
//  Live_TranslateApp.swift
//  Live Translate
//
//  Created by Ken Zhang on 1/18/24.
//

import SwiftUI

@main
struct LiveTranslateApp: App {
    var body: some Scene {
        var user = User()
        
        WindowGroup {
            ContentView()
                .environmentObject(user)
        }
    }
}
