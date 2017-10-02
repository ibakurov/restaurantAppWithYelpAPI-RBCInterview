//
//  Extensions.swift
//  Restaurants
//
//  Created by Illya Bakurov on 10/1/17.
//  Copyright © 2017 ibakurov. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    mutating func remove(_ object: Element) {
        self = filter { $0 != object }
    }
}

extension Date {
    
    static func convertStringDateToDate(dateInString date: String, dateFormatInString format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: date)
    }
    
    static func convertDateToStringDate(date: Date, dateFormatToString format: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}
