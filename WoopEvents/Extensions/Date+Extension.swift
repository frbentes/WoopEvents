//
//  Date+Extension.swift
//  WoopEvents
//
//  Created by Fredyson Costa Marques Bentes on 09/04/20.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation

public extension Date {
    
    func toDDMMYYYY() -> String {
        return self.toFormat("dd/MM/yyyy")
    }
    
    func toDDMM() -> String {
        return self.toFormat("dd/MM")
    }
    
    func toHHmm() -> String {
        return self.toFormat("HH:mm")
    }
    
    init(string: String) {
        guard string != "" && string.count > 0 else {
            self = Date()
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US")
        self = dateFormatter.date(from: string)!
    }
    
    func toFormat(_ format: String, locale: Locale = NSLocale(localeIdentifier: "pt_BR") as Locale) -> String {
        let currentDate = self
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = format
        dateFormatter.locale = locale
        
        let convertedDate: String = dateFormatter.string(from: currentDate)
        
        return convertedDate
    }
    
}

public extension String {
    
    func dateFromString(format: String = "yyyy-MM-dd'T'HH:mm:ssZ") -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        if let date = formatter.date(from: self) {
            return date
        }
        return Date()
    }
    
}
