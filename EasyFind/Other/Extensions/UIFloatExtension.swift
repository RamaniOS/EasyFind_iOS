//
//  UIFloatExtension.swift
//  C0773774_MidTerm_MAD3115F2019
//
//  Created by Nitin Jaswal on 01/11/19.
//  Copyright © 2019 Nitin Jaswal. All rights reserved.
//

import Foundation

extension Float {
    /// used to set as currency.
    func currency() -> String
    {
        // https://stackoverflow.com/questions/41558832/how-to-format-a-double-into-currency-swift-3
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .currency
        let formatmount = formatter.string(from: self as NSNumber)
        let result = String(format: "%@", formatmount!)
        return result
    }
    
    // used to set as Units Usage.
    func unitsUsage() -> String
    {
        let result = String(format: "%.2f MW", self)
        return result
    }
}
