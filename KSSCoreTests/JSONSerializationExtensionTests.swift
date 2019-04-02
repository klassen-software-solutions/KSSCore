//
//  KSSCoreTests.swift
//  KSSCore
//
//  Created by Steven W. Klassen on 2017-04-10.
//  Copyright © 2017 Klassen Software Solutions. All rights reserved.
//

import XCTest
import KSSCore

private struct MyTest {
    var param1 = ""
    var param2 = 0
    var param3 = [String]()
}

private struct MyTest2 {
    var param1 = MyTest()
    var param2 = MyTest()
}

private class MyTest3 {
    var param1 = ""
    var param2 = MyTest2()
}

private class MyTest4: MyTest3 {
    var param3 = 100
}

class JSONSerializationExtensionTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testInAnObject() {
        let obj = MyTest3()
        obj.param1 = "hello"
        obj.param2.param1.param1 = "world"
        obj.param2.param1.param2 = -3
        obj.param2.param1.param3 = [ "hi", "there", "everyone" ]
        obj.param2.param2.param1 = "this"
        obj.param2.param2.param2 = 188

        let data = try! JSONSerialization.data(fromSwiftObject: obj, options: [.prettyPrinted])
        let jsonObj = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        XCTAssert(jsonObj["param1"] as! String == "hello")
    }

    func testInAnArray() {
        let obj = MyTest3()
        obj.param1 = "hello"
        obj.param2.param1.param1 = "world"
        obj.param2.param1.param2 = -3
        obj.param2.param1.param3 = [ "hi", "there", "everyone" ]
        obj.param2.param2.param1 = "this"
        obj.param2.param2.param2 = 188

        let obj2 = MyTest3()
        obj2.param1 = "hello world"


        let ar = [ obj, obj2 ]
        let data = try! JSONSerialization.data(fromSwiftObject: ar, options: [.prettyPrinted])
        //let s = String(data: data, encoding: .utf8)
        //print(s!)
        let jsonAr = try! JSONSerialization.jsonObject(with: data, options: []) as! [Any]
        let jsonObj = jsonAr[0] as! [String: Any]
        XCTAssert(jsonObj["param1"] as! String == "hello")
    }

	func testStruct() {
		var mt1 = MyTest()
		mt1.param1 = "hello"
		mt1.param2 = -23
		mt1.param3 = [ "hello", "there", "world" ]

		let data = try! JSONSerialization.data(fromSwiftObject: mt1)
		let jsonObj = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
		XCTAssert(jsonObj["param1"] as! String == "hello")
		XCTAssert(jsonObj["param2"] as! Int == -23)

		let jsonAr = jsonObj["param3"] as! [String]
		XCTAssert(jsonAr.count == 3)
		XCTAssert(jsonAr[0] == "hello")
		XCTAssert(jsonAr[1] == "there")
		XCTAssert(jsonAr[2] == "world")
	}

    func testThrows() {
        XCTAssert((try? JSONSerialization.data(fromSwiftObject: 3)) == nil)
    }

    func testSubclass() {
        let c = MyTest4()
        c.param1 = "hello world"
        let data = try! JSONSerialization.data(fromSwiftObject: c, options: [.prettyPrinted])
        let jsonObj = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        XCTAssert(jsonObj["param1"] as! String == "hello world")

    }
}
