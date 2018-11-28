//
//  ExtractOtmazaServiceTests.swift
//  OtmazaTests
//
//  Created by Serge Sukhanov on 11/28/18.
//  Copyright © 2018 Serge Sukhanov. All rights reserved.
//

import XCTest
@testable import Otmaza

class ExtractOtmazaServiceTests: XCTestCase {
    let instance = ExtractOtmazaService()
    let correctOtmaza = "correct_otmaza"
    let emptyOtmaza = ""
    let blockquote = ApplicationConstants.Blockquote
    
    func testCorrectOtmazaFoundCorrectly() {
        let correctyBody = "<\(self.blockquote)>&quot\(self.correctOtmaza)&quot<br></\(self.blockquote)>"
        let result = self.instance.extractOtmaza(body: correctyBody)
        XCTAssertEqual(result, "\"\(self.correctOtmaza)\"\n", "otmaza from correct body should be \(self.correctOtmaza)")
    }
    
    func testEmptyBodyReturnsNil() {
        let result = self.instance.extractOtmaza(body: nil)
        XCTAssertNil(result, "empty body should return nil")
    }
    
    func testEmptyOtmazaReturnsNil() {
        let bodyWithEmptyOtmaza = "<\(self.blockquote)>\(self.emptyOtmaza)</\(self.blockquote)>"
        let result = self.instance.extractOtmaza(body: bodyWithEmptyOtmaza)
        XCTAssertNil(result, "empty otmaza should return nil")
    }
    
    func testBodyWithoutBeginningReturnsNil() {
        let bodyWithoutBeginning = "\(self.correctOtmaza)</\(self.blockquote)>"
        let result = self.instance.extractOtmaza(body: bodyWithoutBeginning)
        XCTAssertNil(result, "body without beginning should return nil")
    }
    
    func testBodyWithoutEndingReturnsNil() {
        let bodyWithoutEnding = "<\(self.blockquote)>\(self.correctOtmaza)"
        let result = self.instance.extractOtmaza(body: bodyWithoutEnding)
        XCTAssertNil(result, "body without ending should return nil")
    }
}
