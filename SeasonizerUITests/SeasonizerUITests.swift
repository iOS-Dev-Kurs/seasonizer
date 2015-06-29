//
//  SeasonizerUITests.swift
//  SeasonizerUITests
//
//  Created by Nils Fischer on 29.06.15.
//  Copyright © 2015 Nils Fischer. All rights reserved.
//

import Foundation
import XCTest

class SeasonizerUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddAccessory() {
        let app = XCUIApplication()
        app.toolbars.buttons["Accessories..."].tap()
        app.tables.staticTexts["Sonnenhut"].tap()
        XCTAssertTrue(app.images["sunhat"].exists, "Accessory was not added.")
    }
    
    func testSelectPhoto() {
        let app = XCUIApplication()
        app.toolbars.buttons["Camera"].tap()
        app.sheets.collectionViews.buttons["Foto auswählen"].tap()
        app.tables.buttons["Camera Roll"].tap()
        app.collectionViews.childrenMatchingType(.Cell).matchingIdentifier("Photo, Landscape, August 08, 2012, 11:52 AM").elementAtIndex(0).tap()
    }
    
}
