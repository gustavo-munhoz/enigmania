//
//  UILabel+ext.swift
//  enigmania
//
//  Created by Gustavo Munhoz Correa on 03/08/23.
//

import UIKit

extension UILabel {
    func applyShadowWith(_ color: UIColor?) {
        self.layer.shadowColor = color?.cgColor
        self.layer.shadowOffset = CGSize(width: -3, height: 3)
        self.layer.shadowRadius = 0
        self.layer.shadowOpacity = 2
        self.layer.masksToBounds = false
    }
}
