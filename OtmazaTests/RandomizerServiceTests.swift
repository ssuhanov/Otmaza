//
//  RandomizerServiceTests.swift
//  OtmazaTests
//
//  Created by Serge Sukhanov on 11/28/18.
//  Copyright © 2018 Serge Sukhanov. All rights reserved.
//

import XCTest
@testable import Otmaza

class RandomizerServiceTests: XCTestCase {
    let instance = RandomizerService()
    let maxValue: UInt32 = 2
    
    func testRandomNumberGetsCorrectly() {
        for _ in 0...5 {
            self.randomNumberGetsCorrectly()
        }
    }
    
    func testRandomNumberNotTheSameAsPrevious() {
        for _ in 0...5 {
            self.randomNumberNotTheSameAsPrevious()
        }
    }
    
    private func randomNumberGetsCorrectly() {
        let result = self.instance.getAnotherRandomNumber(currentNumber: 0, maxValue: self.maxValue)
        XCTAssert(result<=maxValue, "random number should be less or equals to \(self.maxValue)")
    }
    
    private func randomNumberNotTheSameAsPrevious() {
        let previousNumber = 1
        let result = self.instance.getAnotherRandomNumber(currentNumber: previousNumber, maxValue: self.maxValue)
        XCTAssertNotEqual(result, previousNumber, "random number should not be equals to \(previousNumber)")
    }
}
