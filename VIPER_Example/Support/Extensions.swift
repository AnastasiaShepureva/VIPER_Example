//
//  Extensions.swift
//  VIPER_Example
//
//  Created by Anastasia Shepureva on 06.02.2021.
//

import Foundation
import UIKit

extension Float {
    var sum: String? {
        
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .decimal
        formatter.roundingMode = .down
        formatter.usesSignificantDigits = false
        formatter.maximumFractionDigits = 2
        
        let strSum = formatter.string(for: self)
        
        if var sum = strSum {
            if sum.hasSuffix(".00") {
                sum.removeLast(2)
            }
            return sum
        }
      return strSum
    }
}

