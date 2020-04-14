//
//  WoopEventsUITests.swift
//  WoopEventsUITests
//
//  Created by Fredyson Costa Marques Bentes on 09/04/20.
//  Copyright © 2020 home. All rights reserved.
//

import XCTest

class WoopEventsUITests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testEventList() {
        let app = XCUIApplication()
        app.launch()
        
        let table = app.tables[AccessibilityIdentifiers.eventTable]
        waitForElementToAppear(table, file: #file, line: #line, elementName: "Event Table", timeout: 5.0)
        
        let identifiers = generateIdentifierList()
        identifiers.forEach { identifier in
            let cell = table.cells[identifier]
            XCTAssertTrue(cell.exists, "\(identifier) cell should be present")
        }
    }
    
    func testEventDetail() {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
        
        let table = app.tables[AccessibilityIdentifiers.eventTable]
        waitForElementToAppear(table, file: #file, line: #line, elementName: "Event Table")
        
        let identifier = "\(AccessibilityIdentifiers.eventCellPrefix) Feira de adoção de animais na Redenção"
        let cell = table.cells[identifier]
        XCTAssertTrue(cell.exists, "\(identifier) cell should be present")
        
        cell.tap()
        
        let tableResume = app.tables[AccessibilityIdentifiers.eventDetailTable]
        waitForElementToAppear(tableResume, file: #file, line: #line, elementName: "Event Resume Table")
        
        let identifierResume = "\(AccessibilityIdentifiers.eventResumeCellPrefix) Feira de adoção de animais na Redenção"
        let cellResume = tableResume.cells[identifierResume]
        XCTAssertTrue(cellResume.exists, "\(identifierResume) cell should be present")
        
        let titleLabel = app.staticTexts[AccessibilityIdentifiers.eventResumeCellTitleLabel]
        XCTAssertEqual(titleLabel.label, "Feira de adoção de animais na Redenção", "Title label should match event")
        
        let dateLabel = app.staticTexts[AccessibilityIdentifiers.eventResumeCellDateLabel]
        XCTAssertEqual(dateLabel.label, "20/08/2018 - 14:00", "Date label should match event")
        
        let locationLabel = app.staticTexts[AccessibilityIdentifiers.eventResumeCellLocationLabel]
        XCTAssertEqual(locationLabel.label, "Porto Alegre, RS, Brasil", "Location label should match event")
        
        let backButton = app.buttons[AccessibilityLabels.eventDetailBackButton]
        XCTAssertTrue(backButton.exists, "Back button should be present")
        
        backButton.tap()
        
        waitForElementToAppear(table, file: #file, line: #line, elementName: "Event Table")
    }
    
    func testCheckin() {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
        
        let table = app.tables[AccessibilityIdentifiers.eventTable]
        waitForElementToAppear(table, file: #file, line: #line, elementName: "Event Table")
        
        let identifier = "\(AccessibilityIdentifiers.eventCellPrefix) Feira de adoção de animais na Redenção"
        let cell = table.cells[identifier]
        XCTAssertTrue(cell.exists, "\(identifier) cell should be present")
        
        cell.tap()
        
        let tableResume = app.tables[AccessibilityIdentifiers.eventDetailTable]
        waitForElementToAppear(tableResume, file: #file, line: #line, elementName: "Event Resume Table")
        
        let identifierResume = "\(AccessibilityIdentifiers.eventResumeCellPrefix) Feira de adoção de animais na Redenção"
        let cellResume = tableResume.cells[identifierResume]
        XCTAssertTrue(cellResume.exists, "\(identifierResume) cell should be present")
        
        let backEventsButton = app.buttons[AccessibilityLabels.eventDetailBackButton]
        XCTAssertTrue(backEventsButton.exists, "Back events button should be present")
        
        let checkinButton = app.buttons[AccessibilityLabels.checkinButton]
        XCTAssertTrue(checkinButton.exists, "Checkin button should be present")
        
        checkinButton.tap()
        
        let confirmButton = app.buttons[AccessibilityLabels.checkinConfirmButton]
        XCTAssertTrue(confirmButton.exists, "Confirm button should be present")
        
        let backCheckinButton = app.buttons[AccessibilityLabels.checkinBackButton]
        XCTAssertTrue(backCheckinButton.exists, "Back checkin button should be present")
        
        backCheckinButton.tap()
        backEventsButton.tap()
        
        waitForElementToAppear(table, file: #file, line: #line, elementName: "Event Table")
    }
    
    func generateIdentifierList() -> [String] {
        let titles = [
            "Feira de adoção de animais na Redenção",
            "Doação de roupas",
            "Feira de Troca de Livros"
        ]
        
        let identifiers = titles.map { title in
            return "\(AccessibilityIdentifiers.eventCellPrefix) \(title)"
        }
        
        return identifiers
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
