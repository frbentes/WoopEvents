//
//  AccessibilityIdentifiers.swift
//  WoopEvents
//
//  Created by Fredyson Costa Marques Bentes on 14/04/20.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation

enum AccessibilityIdentifiers {
    
    // event list
    static let eventTable = "eventTable"
    static let eventCellPrefix = "eventCell"
    static let eventCellTitleLabel = "eventCellTitleLabel"
    
    // event detail
    static let eventDetailTable = "eventDetailTable"
    static let eventResumeCellPrefix = "eventResumeCell"
    static let eventResumeCellTitleLabel = "eventResumeCellTitleLabel"
    static let eventResumeCellDateLabel = "eventResumeCellDateLabel"
    static let eventResumeCellLocationLabel = "eventResumeCellLocationLabel"
    
    // checkin
    static let checkinTitleButton = "checkinTitleButton"
    
    static func eventCellIdentifier(forTitle title: String) -> String {
        return "\(AccessibilityIdentifiers.eventCellPrefix) \(title)"
    }
    
    static func eventResumeCellIdentifier(forTitle title: String) -> String {
        return "\(AccessibilityIdentifiers.eventResumeCellPrefix) \(title)"
    }
    
}
