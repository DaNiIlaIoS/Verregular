//
//  UIView+Ex.swift
//  Verregular
//
//  Created by Даниил Сивожелезов on 31.05.2024.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { view in
            addSubview(view)
        }
    }
}
