//
//  DateExtension.swift
//  C0773774_MidTerm_MAD3115F2019
//
//  Created by Nitin on 06/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

extension Date {
    
    func toString(withFormat format: String = "EEEE, dd MMMM, YYYY") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    static func dateDifference(startDate: String, endDate: String) -> String {
        let start = startDate.toDate()
        let end = endDate.toDate()
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.month]
        formatter.unitsStyle = .full
        if let differenceString = formatter.string(from: start, to: end) {
            return differenceString
        }
        return "No Date Found"
    }
}
