//
//  Verb.swift
//  Verregular
//
//  Created by Даниил Сивожелезов on 31.05.2024.
//

import Foundation

struct Verb {
    let infinitive: String
    let pastSimple: String
    let participle: String
    
    var translation: String {
        return infinitive.localized
    }
}
