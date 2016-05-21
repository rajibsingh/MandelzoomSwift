//
//  MandelzoomSwiftTests.swift
//  MandelzoomSwiftTests
//
//  Created by Rajib Singh on 4/16/16.
//  Copyright © 2016 Sepoy Software. All rights reserved.
//

import XCTest
@testable import MandelzoomSwift

class MandelzoomSwiftTests: XCTestCase {

    private var tl: ComplexNumber = ComplexNumber(x: -1.0, y: 0.75)
    private var br: ComplexNumber = ComplexNumber(x: 0.5, y: -1)


    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            let renderer: MandelbrotRenderer = MandelbrotRenderer(height: 200, width: 200, topLeft: self.tl, bottomRight: self.br)
            let image = renderer.getImage()
        }
    }

    func testComplexNumbers() {
        let c = ComplexNumber(x: 1, y: 1)
        var t1 = c.square()
        XCTAssertEqual(t1.x, 0)
        XCTAssertEqual(t1.y, 2)

        t1 = t1.add(c)
        XCTAssertEqual(t1.x, 1)
        XCTAssertEqual(t1.y, 3)

        t1 = t1.square()
        XCTAssertEqual(t1.x, -8)
        XCTAssertEqual(t1.y, 6)

        t1 = t1.add(c)
        XCTAssertEqual(t1.x, -7)
        XCTAssertEqual(t1.y, 7)

        t1 = t1.square()
        XCTAssertEqual(t1.x, 0)
        XCTAssertEqual(t1.y, -98)

        t1 = t1.add(c)
        XCTAssertEqual(t1.x, 1)
        XCTAssertEqual(t1.y, -97)
    }

    func testMoreComplexNumbers() {
        //-2+3i
        let c = ComplexNumber(x: -2, y: 3)
        var c2 = c.square()
        XCTAssertEqual(c2.x, -5)
        XCTAssertEqual(c2.y, -12)
    }

    func testRenderer() {
        let tl: ComplexNumber = ComplexNumber(x: -1.0, y: 0.75)
        let br: ComplexNumber = ComplexNumber(x: 0.5, y: -1)
        let renderer: MandelbrotRenderer = MandelbrotRenderer(height: 200, width: 200, topLeft: tl, bottomRight: br)
        // check that renderer was created
        XCTAssertNotNil(renderer)
        // check that render can return a picture
        let image = renderer.getImage()
        XCTAssertNotNil(image)
    }
    
}
