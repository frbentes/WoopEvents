//
//  XCTestCase+Helpers.swift
//  WoopEventsUITests
//
//  Created by Fredyson Costa Marques Bentes on 14/04/20.
//  Copyright © 2020 home. All rights reserved.
//

import XCTest

extension XCTestCase {
    func waitForElementToAppear(_ element: XCUIElement,
                                file: StaticString,
                                line: UInt,
                                elementName: String,
                                timeout: TimeInterval = 5.0) {
        let predicate = NSPredicate(format: "exists == true")
        let existsExpectation = expectation(for: predicate,
                                            evaluatedWith: element,
                                            handler: nil)
        let result = XCTWaiter().wait(for: [existsExpectation],
                                      timeout: timeout)
        guard result == .completed else {
            let failureMessage = "\(elementName) should be present)"
            XCTFail(failureMessage, file: file, line: line)
            return
        }
    }
}

