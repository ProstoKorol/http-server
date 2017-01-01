/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

import XCTest
@testable import HTTPMessage

class BugTests: XCTestCase {
    let simpleGet = ASCII("GET /test HTTP/1.1\r\n\r\n")
    func testStringTerminationBug() {
        if !_isDebugAssertConfiguration() {
            for _ in 0..<1_000_000 {
                if let request = try? HTTPRequest(fromBytes: simpleGet) {
                    if !request.urlBytes.elementsEqual(ASCII("/test")) {
                        XCTFail("(\"\(request.url)\") in not equal to (\"Optional(\"/test\")\")")
                        break
                    }
                }
            }
        }
    }

    static var allTests : [(String, (BugTests) -> () throws -> Void)] {
        return [
            ("testStringTerminationBug", testStringTerminationBug),
        ]
    }
}
