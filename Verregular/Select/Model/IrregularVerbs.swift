//
//  IrregularVerbs.swift
//  Verregular
//
//  Created by Даниил Сивожелезов on 31.05.2024.
//

import Foundation

final class IrregularVerbs {
    
    // MARK: - Singletone
    static let shared = IrregularVerbs()
    private init() {
        configureVerbs()
        selectedVerbs = verbs
        configureSection()
    }
    
    // MARK: - Properties
    private(set) var verbs: [Verb] = []
    private(set) var sections: [VerbsTableViewSection] = []
    var selectedVerbs: [Verb] = []
    
    // MARK: - Methods
    private func configureVerbs() {
        verbs = [Verb(infinitive: "blow", pastSimple: "blew", participle: "blown"),
                 Verb(infinitive: "be", pastSimple: "was/were", participle: "been"),
                 Verb(infinitive: "become", pastSimple: "became", participle: "become"),
                 Verb(infinitive: "begin", pastSimple: "began", participle: "begun"),
                 
                 Verb(infinitive: "catch", pastSimple: "caught", participle: "caught"),
                 Verb(infinitive: "choose", pastSimple: "chose", participle: "chosen"),
                 Verb(infinitive: "come", pastSimple: "came", participle: "come"),
                 Verb(infinitive: "cost", pastSimple: "cost", participle: "cost"),
                 
                 Verb(infinitive: "do", pastSimple: "did", participle: "done"),
                 Verb(infinitive: "draw", pastSimple: "drew", participle: "drawn"),
                 Verb(infinitive: "drink", pastSimple: "drank", participle: "drunk"),
                 Verb(infinitive: "drive", pastSimple: "drove", participle: "driven"),
                 
                 Verb(infinitive: "eat", pastSimple: "ate", participle: "eaten"),
                 
                 Verb(infinitive: "fall", pastSimple: "fell", participle: "fallen"),
                 Verb(infinitive: "feel", pastSimple: "felt", participle: "felt"),
                 Verb(infinitive: "find", pastSimple: "found", participle: "found"),
                 Verb(infinitive: "forget", pastSimple: "forgot", participle: "forgotten")]
    }
    
    private func configureSection() {
        let groupedDictionary = Dictionary(grouping: verbs, by: { $0.infinitive.prefix(1).uppercased() })
        sections = groupedDictionary.map { VerbsTableViewSection(title: String($0.key), verbs: $0.value.sorted { $0.infinitive < $1.infinitive }) }
        sections.sort { $0.title < $1.title }
    }
}
