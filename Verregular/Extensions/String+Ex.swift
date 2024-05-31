//
//  String+Ex.swift
//  Verregular
//
//  Created by Даниил Сивожелезов on 30.05.2024.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
