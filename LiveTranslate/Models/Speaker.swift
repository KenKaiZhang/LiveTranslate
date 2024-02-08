//
//  Speaker.swift
//  LiveTranslate
//
//  Created by Ken Zhang on 1/22/24.
//

import Foundation

struct Speaker: Hashable{
    let id: UUID
    var name: String
    var main: Bool
    var language: Language
    
    init(id: UUID = UUID(), name: String, language: Language, main: Bool) {
        self.id = id
        self.name = name
        self.main = main
        self.language = language
    }
}

extension Speaker: Equatable {
    static func == (lhs: Speaker, rhs: Speaker) -> Bool {
        return lhs.id == rhs.id
    }
}
