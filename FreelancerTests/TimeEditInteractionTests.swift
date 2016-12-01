//
//  TimeEditInteractionTests.swift
//  Freelancer
//
//  Created by Denys Meloshyn on 30.11.16.
//  Copyright © 2016 Denys Meloshyn. All rights reserved.
//

import XCTest
@testable import Freelancer

class TimeEditInteractionTests: XCTestCase {
    var time: LoggedTime?
    let calendar = Calendar.current
    let interaction = TimeEditInteraction()
    let timeUnits = Set<Calendar.Component>([.hour, .minute, .second])
    let allUnits = Set<Calendar.Component>([.hour, .minute, .second, .year, .month, .day, .nanosecond])
    let managedObjectContext = ModelManager.createChildrenManagedObjectContext(from: ModelManager.sharedInstance.managedObjectContext)
    
    override func setUp() {
        super.setUp()
        
        self.time = LoggedTime(context: managedObjectContext)
        
        let initDate = NSDate()
        self.time?.start = initDate
        self.time?.finish = initDate
        
        self.interaction.currentTime = self.time
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testIncrasingTineOneSecond() {
        var startDateComponents = self.calendar.dateComponents(self.allUnits, from: self.time?.start! as! Date)
        startDateComponents.second = startDateComponents.second! + 1
        
        self.interaction.increaseTimeOneSecond()
        
        let expectedDate = self.calendar.date(from: startDateComponents)
        let resultDate = self.time?.finish! as! Date
        XCTAssertEqual(expectedDate!.timeIntervalSinceReferenceDate, resultDate.timeIntervalSinceReferenceDate)
    }
    
    func testAddManualMinuteTime() {
        let minute = 60
        
        var addDateComponents = DateComponents()
        addDateComponents.minute = minute
        let addDate = self.calendar.date(from: addDateComponents)
        
        var startDateComponents = calendar.dateComponents(self.allUnits, from: self.time?.start! as! Date)
        startDateComponents.minute = startDateComponents.minute! + minute
        let expectedDate = self.calendar.date(from: startDateComponents)
        
        self.interaction.addDate(addDate!)
        
        let resultDate = self.time?.finish! as! Date
        XCTAssertEqual(expectedDate!.timeIntervalSinceReferenceDate, resultDate.timeIntervalSinceReferenceDate)
    }
    
    func testAddManualHourTime() {
        let value = 4
        
        var addDateComponents = DateComponents()
        addDateComponents.hour = value
        let addDate = self.calendar.date(from: addDateComponents)
        
        var startDateComponents = calendar.dateComponents(self.allUnits, from: self.time?.start! as! Date)
        startDateComponents.hour = startDateComponents.hour! + value
        let expectedDate = self.calendar.date(from: startDateComponents)
        
        self.interaction.addDate(addDate!)
        
        let resultDate = self.time?.finish! as! Date
        XCTAssertEqual(expectedDate!.timeIntervalSinceReferenceDate, resultDate.timeIntervalSinceReferenceDate)
    }
    
    func testAddManualExtraHourTime() {
        let value = 23
        
        let addDate = self.interaction.generateDate(with: value, minute: 0, second: 0)
        
        var startDateComponents = calendar.dateComponents(self.allUnits, from: self.time?.start! as! Date)
        startDateComponents.hour = startDateComponents.hour! + value
        let expectedDate = self.calendar.date(from: startDateComponents)
        
        self.interaction.addDate(addDate!)
        
        let resultDate = self.time?.finish! as! Date
        XCTAssertEqual(expectedDate!.timeIntervalSinceReferenceDate, resultDate.timeIntervalSinceReferenceDate)
    }
    
    func testAddManualExtraHourMultipleTimes() {
        let value = 23
        
        let addDate = self.interaction.generateDate(with: value, minute: 0, second: 0)
        self.interaction.addDate(addDate!)
        self.interaction.addDate(addDate!)
        self.interaction.addDate(addDate!)
        
        var startDateComponents = calendar.dateComponents(self.allUnits, from: self.time?.start! as! Date)
        startDateComponents.hour = startDateComponents.hour! + value * 3
        let expectedDate = self.calendar.date(from: startDateComponents)
        
        let resultDate = self.time?.finish! as! Date
        XCTAssertEqual(expectedDate!.timeIntervalSinceReferenceDate, resultDate.timeIntervalSinceReferenceDate)
    }
    
    func testSusbtractManualMinuteTime() {
        let value = 20
        let substractValue = 10
        let addDate = self.interaction.generateDate(with: 0, minute: value, second: 0)
        self.interaction.addDate(addDate!)
        
        let substractDate = self.interaction.generateDate(with: 0, minute: substractValue, second: 0)
        self.interaction.subtractDate(substractDate!)
        
        var startDateComponents = calendar.dateComponents(self.allUnits, from: self.time?.start! as! Date)
        startDateComponents.minute = startDateComponents.minute! + value - substractValue
        let expectedDate = self.calendar.date(from: startDateComponents)
        
        let resultDate = self.time?.finish! as! Date
        XCTAssertEqual(expectedDate!.timeIntervalSinceReferenceDate, resultDate.timeIntervalSinceReferenceDate)
    }
    
    func testSusbtractMoreThanPossible() {
        let value = 20
        let substractValue = 30
        let addDate = self.interaction.generateDate(with: 0, minute: value, second: 0)
        self.interaction.addDate(addDate!)
        
        let substractDate = self.interaction.generateDate(with: 0, minute: substractValue, second: 0)
        self.interaction.subtractDate(substractDate!)
        
        let expectedDate = self.time?.start! as! Date
        let resultDate = self.time?.finish! as! Date
        XCTAssertEqual(expectedDate.timeIntervalSinceReferenceDate, resultDate.timeIntervalSinceReferenceDate)
    }

    func testSusbtractManualMultipleTimes() {
        let addDate = self.interaction.generateDate(with: 0, minute: 40, second: 0)
        self.interaction.addDate(addDate!)

        let substractDate = self.interaction.generateDate(with: 0, minute: 10, second: 0)
        self.interaction.subtractDate(substractDate!)
        self.interaction.subtractDate(substractDate!)
        self.interaction.subtractDate(substractDate!)

        var startDateComponents = calendar.dateComponents(self.allUnits, from: self.time?.start! as! Date)
        startDateComponents.minute = startDateComponents.minute! + 10
        let expectedDate = self.calendar.date(from: startDateComponents)

        let resultDate = self.time?.finish! as! Date
        XCTAssertEqual(expectedDate!.timeIntervalSinceReferenceDate, resultDate.timeIntervalSinceReferenceDate)
    }

    func testSusbtractManualMultipleTimesMoreThanPossible() {
        let addDate = self.interaction.generateDate(with: 0, minute: 1, second: 0)
        self.interaction.addDate(addDate!)

        let substractDate = self.interaction.generateDate(with: 0, minute: 10, second: 0)
        self.interaction.subtractDate(substractDate!)
        self.interaction.subtractDate(substractDate!)
        self.interaction.subtractDate(substractDate!)

        let expectedDate = self.time?.start! as! Date
        let resultDate = self.time?.finish! as! Date
        XCTAssertEqual(expectedDate.timeIntervalSinceReferenceDate, resultDate.timeIntervalSinceReferenceDate)
    }
}
