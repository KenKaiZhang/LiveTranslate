//
//  DocumentDirectory.swift
//  LiveTranslate
//
//  Created by Ken Zhang on 2/1/24.
//

import Foundation

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}
