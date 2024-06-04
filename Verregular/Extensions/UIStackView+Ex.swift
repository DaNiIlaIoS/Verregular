//
//  UIStackView+Ex.swift
//  Verregular
//
//  Created by Даниил Сивожелезов on 31.05.2024.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { view in
            addArrangedSubview(view)
        }
    }
}
