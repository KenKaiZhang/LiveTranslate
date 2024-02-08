//
//  User.swift
//  LiveTranslate
//
//  Created by Ken Zhang on 1/31/24.
//

import Foundation
import SwiftUI

public class User: ObservableObject {
    @Published var mainTheme: Theme = .azure
    @Published var secondaryTheme: Theme = .lime
    static var defaultTheme: Theme = .ash
}
