//
//  UIColor+Hex.swift
//  ReactionTimeTest
//
//  Created by Madimo on 2017/3/9.
//  Copyright © 2017年 Madimo. All rights reserved.
//

import UIKit

extension UIColor {

    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)

        if hex.isEmpty {
            self.init(white: 0, alpha: 0)
            return
        }

        let scanner = Scanner(string: hex)
        if hex.hasPrefix("#") {
            scanner.scanLocation = 1
        }

        var color: UInt32 = 0
        scanner.scanHexInt32(&color)

        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask

        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
}
