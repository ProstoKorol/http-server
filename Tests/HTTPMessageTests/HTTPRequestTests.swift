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

struct HTTPRequests {
    // Start line
    static let simpleDelete = "DELETE /test HTTP/1.1\r\n\r\n"
    static let simpleGet = "GET /test HTTP/1.1\r\n\r\n"
    static let simpleHead = "HEAD /test HTTP/1.1\r\n\r\n"
    static let simplePost = "POST /test HTTP/1.1\r\n\r\n"
    static let simplePut = "PUT /test HTTP/1.1\r\n\r\n"
    static let simpleOnlyMethod = "GET\r\n\r\n"
    static let simpleOnlyMethod2 = "GET \r\n\r\n"
    static let simpleInvalidMethod = "BAD /test HTTP/1.1\r\n\r\n"
    static let simpleInvalidVersion = "GET /test HTTP/0.1\r\n\r\n"
    static let simpleInvalidVersion2 = "GET /test HTTP/1.1WUT\r\n\r\n"
    static let simpleInvalidVersion3 = "GET /test HTTP/1."
    static let simpleInvalidVersion4 = "GET /test HTPP/1.1\r\n\r\n"
    static let simpleInvalidEnd = "GET /test HTTP/1.1\r\n"
    // Headers
    static let startLine = "GET / HTTP/1.1\r\n"
    static let hostHeader = "\(startLine)Host: 0.0.0.0=5000\r\n\r\n"
    static let userAgentHeader = "\(startLine)User-Agent: Mozilla/5.0\r\n\r\n"
    static let twoHeaders = "\(startLine)Host: 0.0.0.0=5000\r\nUser-Agent: Mozilla/5.0\r\n\r\n"
    static let twoHeadersOptionalSpaces = "\(startLine)Host:0.0.0.0=5000\r\nUser-Agent: Mozilla/5.0 \r\n\r\n"
    static let invalidHeaderColon = "\(startLine)User-Agent; Mozilla/5.0\r\n\r\n"
    static let invalidHeaderEnd = "\(startLine)User-Agent: Mozilla/5.0\n\n"
    static let invalidHeaderName = "\(startLine)See-🙈-Evil: No\n\n"
    static let unexpectedEnd = "\(startLine)Header: Value\r\n"
    static let contentLength = "\(startLine)Content-Length: 5\r\n\r\nHello"
    static let keepAliveFalse = "\(startLine)Connection: Close\r\n\r\n"
    static let keepAliveTrue = "\(startLine)Connection: Keep-Alive\r\nKeep-Alive: 300\r\n\r\n"
    static let transferEncodingChunked = "\(startLine)Transfer-Encoding: chunked\r\n\r\n"
    // Body
    static let chunkedBody = "\(transferEncodingChunked)5\r\nHello\r\n0\r\n"
    static let chunkedBodyInvalidSizeSeparator = "\(transferEncodingChunked)5\rHello\r\n0\r\n"
    static let chunkedBodyNoSizeSeparator = "\(transferEncodingChunked)5 Hello\r\n0\r\n"
    static let chunkedInvalidBody = "\(transferEncodingChunked)5\r\nHello"
    static let chunkedJunkAfterBody = "\(chunkedBody)wuut"
}

class HTTPRequestTests: XCTestCase {
    func testHTTPRequestType() {
        let httpRequest: HTTPType = .request
        XCTAssertEqual(httpRequest, .request)
    }

    func testHTTPResponseType() {
        let httpResponse: HTTPType = .response
        XCTAssertEqual(httpResponse, .response)
    }

//    func testHTTPRequest() {
//        let httpRequest = HTTPRequest()
//        XCTAssertNotNil(httpRequest)
//    }

    func testHTTPRequestFromBytes() throws {
        let httpRequest = try HTTPRequest(fromBytes: ASCII(HTTPRequests.simpleGet))
        XCTAssertNotNil(httpRequest)
    }

    func testHTTPRequestDelete() throws {
        let httpRequest = try HTTPRequest(fromBytes: ASCII(HTTPRequests.simpleDelete))
        XCTAssertNotNil(httpRequest)
        XCTAssertEqual(httpRequest.type, HTTPRequestType.delete)
    }

    func testHTTPRequestGet() throws {
        let httpRequest = try HTTPRequest(fromBytes: ASCII(HTTPRequests.simpleGet))
        XCTAssertNotNil(httpRequest)
        XCTAssertEqual(httpRequest.type, HTTPRequestType.get)
    }

    func testHTTPRequestHead() throws {
        let httpRequest = try HTTPRequest(fromBytes: ASCII(HTTPRequests.simpleHead))
        XCTAssertNotNil(httpRequest)
        XCTAssertEqual(httpRequest.type, HTTPRequestType.head)
    }

    func testHTTPRequestPost() throws {
        let httpRequest = try HTTPRequest(fromBytes: ASCII(HTTPRequests.simplePost))
        XCTAssertNotNil(httpRequest)
        XCTAssertEqual(httpRequest.type, HTTPRequestType.post)
    }

    func testHTTPRequestPut() throws {
        let httpRequest = try HTTPRequest(fromBytes: ASCII(HTTPRequests.simplePut))
        XCTAssertNotNil(httpRequest)
        XCTAssertEqual(httpRequest.type, HTTPRequestType.put)
    }

    func testHTTPVersion() throws {
        let httpRequest = try HTTPRequest(fromBytes: ASCII(HTTPRequests.simpleGet))
        XCTAssertNotNil(httpRequest)
        XCTAssertEqual(httpRequest.version, HTTPVersion.oneOne)

    }

    func testHTTPRequestUrl() throws {
        let httpRequest = try HTTPRequest(fromBytes: ASCII(HTTPRequests.simpleGet))
        XCTAssertNotNil(httpRequest)
        XCTAssertNotNil(httpRequest.url)
        XCTAssertEqual(httpRequest.urlBytes, ASCII("/test"))
    }

    func testHTTPRequestUrlString() throws {
        let httpRequest = try HTTPRequest(fromBytes: ASCII(HTTPRequests.simpleGet))
        XCTAssertNotNil(httpRequest)
        XCTAssertNotNil(httpRequest.url)
        XCTAssertEqual(httpRequest.url, "/test")
    }

    func testInvalidRequest() throws {
        do {
            _ = try HTTPRequest(fromBytes: ASCII(HTTPRequests.simpleOnlyMethod))
            XCTFail("this method should throw")
        } catch let error as HTTPRequestError {
            XCTAssertEqual(error, .invalidRequest)
        }
    }

    func testInvalidRequest2() throws {
        do {
            _ = try HTTPRequest(fromBytes: ASCII(HTTPRequests.simpleOnlyMethod2))
            XCTFail("this method should throw")
        } catch let error as HTTPRequestError {
            XCTAssertEqual(error, .invalidRequest)
        }
    }

    func testInvalidHTTPRequestMethod() throws {
        do {
            _ = try HTTPRequest(fromBytes: ASCII(HTTPRequests.simpleInvalidMethod))
            XCTFail("this method should throw")
        } catch let error as HTTPRequestError {
            XCTAssertEqual(error, .invalidMethod)
        }
    }

    func testInvalidHTTPRequestVersion() throws {
        do {
            _ = try HTTPRequest(fromBytes: ASCII(HTTPRequests.simpleInvalidVersion))
            XCTFail("this method should throw")
        } catch let error as HTTPRequestError {
            XCTAssertEqual(error, .invalidVersion)
        }
    }

    func testInvalidHTTPRequestVersion2() throws {
        do {
            _ = try HTTPRequest(fromBytes: ASCII(HTTPRequests.simpleInvalidVersion2))
            XCTFail("this method should throw")
        } catch let error as HTTPRequestError {
            XCTAssertEqual(error, .invalidRequest)
        }
    }

    func testInvalidHTTPRequestVersion3() throws {
        do {
            _ = try HTTPRequest(fromBytes: ASCII(HTTPRequests.simpleInvalidVersion3))
            XCTFail("this method should throw")
        } catch let error as HTTPRequestError {
            XCTAssertEqual(error, .unexpectedEnd)
        }
    }

    func testInvalidHTTPRequestVersion4() throws {
        do {
            _ = try HTTPRequest(fromBytes: ASCII(HTTPRequests.simpleInvalidVersion4))
            XCTFail("this method should throw")
        } catch let error as HTTPRequestError {
            XCTAssertEqual(error, .invalidVersion)
        }
    }

    func testInvalidHTTPRequestEnd() throws {
        do {
            _ = try HTTPRequest(fromBytes: ASCII(HTTPRequests.simpleInvalidEnd))
            XCTFail("this method should throw")
        } catch let error as HTTPRequestError {
            XCTAssertEqual(error, .unexpectedEnd)
        }
    }

    func testHTTPRequestHostHeader() throws {
        let request = try HTTPRequest(fromBytes: ASCII(HTTPRequests.hostHeader))
        XCTAssertNotNil(request.host)
        if let host = request.host {
            XCTAssertEqual(host, "0.0.0.0=5000")
        }
    }

    func testHTTPRequestUserAgentHeader() throws {
        let request = try HTTPRequest(fromBytes: ASCII(HTTPRequests.userAgentHeader))
        XCTAssertNotNil(request.userAgent)
        if let userAgent = request.userAgent {
            XCTAssertEqual(userAgent, "Mozilla/5.0")
        }
    }

    func testHTTPRequestTwoHeaders() throws {
        let request = try HTTPRequest(fromBytes: ASCII(HTTPRequests.twoHeaders))
        XCTAssertNotNil(request.host)
        XCTAssertNotNil(request.userAgent)
        if let userAgent = request.userAgent, let host = request.host {
            XCTAssertEqual(host, "0.0.0.0=5000")
            XCTAssertEqual(userAgent, "Mozilla/5.0")
        }
    }

    func testHTTPRequestTwoHeadersOptionalSpaces() throws {
        let request = try HTTPRequest(fromBytes: ASCII(HTTPRequests.twoHeadersOptionalSpaces))
        XCTAssertNotNil(request.host)
        XCTAssertNotNil(request.userAgent)
        if let userAgent = request.userAgent, let host = request.host {
            XCTAssertEqual(host, "0.0.0.0=5000")
            XCTAssertEqual(userAgent, "Mozilla/5.0")
        }
    }

    func testInvalidHeaderColon() throws {
        do {
            _ = try HTTPRequest(fromBytes: ASCII(HTTPRequests.invalidHeaderColon))
            XCTFail("this method should throw")
        } catch let error as HTTPRequestError {
            XCTAssertEqual(error, .invalidHeaderName)
        }
    }

    func testInvalidHeaderName() throws {
        do {
            _ = try HTTPRequest(fromBytes: ASCII(HTTPRequests.invalidHeaderName))
            XCTFail("this method should throw")
        } catch let error as HTTPRequestError {
            XCTAssertEqual(error, .invalidHeaderName)
        }
    }

    func testInvalidHeaderEnd() throws {
        do {
            _ = try HTTPRequest(fromBytes: ASCII(HTTPRequests.invalidHeaderEnd))
            XCTFail("this method should throw")
        } catch let error as HTTPRequestError {
            XCTAssertEqual(error, .unexpectedEnd)
        }
    }

    func testHeaderName() {
        let headerName = HeaderName(extendedGraphemeClusterLiteral: "Host")
        let headerName2 = HeaderName(unicodeScalarLiteral: "Host")
        XCTAssertEqual(headerName, headerName2)
    }

    func testUnexpectedEnd() throws {
        do {
            _ = try HTTPRequest(fromBytes: ASCII(HTTPRequests.unexpectedEnd))
            XCTFail("this method should throw")
        } catch let error as HTTPRequestError {
            XCTAssertEqual(error, .unexpectedEnd)
        }
    }

    func testContentLenght() throws {
        do {
            let request = try HTTPRequest(fromBytes: ASCII(HTTPRequests.contentLength))
            XCTAssertNotNil(request.contentLength)
            if let contentLength = request.contentLength {
                XCTAssertEqual(contentLength, 5)
            }
        } catch let error as HTTPRequestError {
            XCTFail("unexpected exception: \(error)")
        }
    }

    func testKeepAliveFalse() throws {
        let request = try HTTPRequest(fromBytes: ASCII(HTTPRequests.keepAliveFalse))
        XCTAssertFalse(request.shouldKeepAlive)
    }

    func testKeepAliveTrue() throws {
        let request = try HTTPRequest(fromBytes: ASCII(HTTPRequests.keepAliveTrue))
        XCTAssertTrue(request.shouldKeepAlive)
        XCTAssertEqual(request.keepAlive, 300)
    }

    func testTransferEncodingChunked() throws {
        let request = try HTTPRequest(fromBytes: ASCII(HTTPRequests.transferEncodingChunked))
        XCTAssertEqual(request.transferEncoding?.lowercased(), "chunked")
    }

    func testChunkedBody() throws {
        let request = try HTTPRequest(fromBytes: ASCII(HTTPRequests.chunkedBody))
        XCTAssertEqual(request.body, "Hello")
    }

    func testChunkedBodyInvalidSizeSeparator() throws {
        do {
            _ = try HTTPRequest(fromBytes: ASCII(HTTPRequests.chunkedBodyInvalidSizeSeparator))
            XCTFail("this method should throw")
        } catch let error as HTTPRequestError {
            XCTAssertEqual(error, .invalidRequest)
        }
    }

    func testChunkedBodyNoSizeSeparator() throws {
        do {
            _ = try HTTPRequest(fromBytes: ASCII(HTTPRequests.chunkedBodyNoSizeSeparator))
            XCTFail("this method should throw")
        } catch let error as HTTPRequestError {
            XCTAssertEqual(error, .invalidRequest)
        }
    }

    func testChunkedInvalidBody() throws {
        do {
            _ = try HTTPRequest(fromBytes: ASCII(HTTPRequests.chunkedInvalidBody))
            XCTFail("this method should throw")
        } catch let error as HTTPRequestError {
            XCTAssertEqual(error, .unexpectedEnd)
        }
    }

    func testChunkedJunkAfterBody() throws {
        do {
            _ = try HTTPRequest(fromBytes: ASCII(HTTPRequests.chunkedJunkAfterBody))
            XCTFail("this method should throw")
        } catch let error as HTTPRequestError {
            XCTAssertEqual(error, .unexpectedEnd)
        }
    }

    // http_parser.c took 75 ms on my machine
    // quark 19_000 ms (6_500 ms without stream)
    // kitura 7_228 ms
    // perfect 46_362 ms
    // CaseInsensitiveString - 2_927
    // String 1_976
    // HeaderName 0_952 ms
    // HeaderName Slices = 0_768 ms
    // HeaderName Lazy = 2_020 ms
    //
    func testPreformanceLite() {
        if !_isDebugAssertConfiguration() {
            let firefoxGet = ASCII(NginxHTTPRequests.firefoxGet)
            self.measure {
                for _ in 0 ..< 100_000 {
                    _ = try! HTTPRequest(fromBytes: firefoxGet)
                }
            }
        }
    }

    func testPreformanceChunkedBody() {
        if !_isDebugAssertConfiguration() {
            let chankedAllYourBase = ASCII(NginxHTTPRequests.chankedAllYourBase)
            self.measure {
                for _ in 0 ..< 100_000 {
                    _ = try! HTTPRequest(fromBytes: chankedAllYourBase)
                }
            }
        }
    }

    func testPreformanceFull() {
        if !_isDebugAssertConfiguration() {
            let firefoxGet = ASCII(NginxHTTPRequests.firefoxGet)
            self.measure {
                for _ in 0 ..< 100_000 {
                    let request = try! HTTPRequest(fromBytes: firefoxGet)
                    _ = request.url
                    _ = request.host
                    _ = request.userAgent
                    _ = request.accept
                    _ = request.acceptLanguage
                    _ = request.acceptEncoding
                    _ = request.acceptCharset
                    _ = request.shouldKeepAlive
                    _ = request.keepAlive
                    _ = request.connection
                }
            }
        }
    }

    static var allTests : [(String, (HTTPRequestTests) -> () throws -> Void)] {
        return [
            ("testHTTPRequestType", testHTTPRequestType),
            ("testHTTPResponseType", testHTTPResponseType),
//            ("testHTTPRequest", testHTTPRequest),
            ("testHTTPRequestFromBytes", testHTTPRequestFromBytes),
            ("testHTTPRequestDelete", testHTTPRequestDelete),
            ("testHTTPRequestGet", testHTTPRequestGet),
            ("testHTTPRequestHead", testHTTPRequestHead),
            ("testHTTPRequestPost", testHTTPRequestPost),
            ("testHTTPRequestPut", testHTTPRequestPut),
            ("testHTTPVersion", testHTTPVersion),
            ("testHTTPRequestUrl", testHTTPRequestUrl),
            ("testHTTPRequestUrlString", testHTTPRequestUrlString),
            ("testInvalidRequest", testInvalidRequest),
            ("testInvalidRequest", testInvalidRequest2),
            ("testInvalidHTTPRequestMethod", testInvalidHTTPRequestMethod),
            ("testInvalidHTTPRequestVersion", testInvalidHTTPRequestVersion),
            ("testInvalidHTTPRequestVersion2", testInvalidHTTPRequestVersion2),
            ("testInvalidHTTPRequestVersion3", testInvalidHTTPRequestVersion3),
            ("testInvalidHTTPRequestVersion4", testInvalidHTTPRequestVersion4),
            ("testInvalidHTTPRequestEnd", testInvalidHTTPRequestEnd),
            ("testHTTPRequestHostHeader", testHTTPRequestHostHeader),
            ("testHTTPRequestUserAgentHeader", testHTTPRequestUserAgentHeader),
            ("testHTTPRequestTwoHeaders", testHTTPRequestTwoHeaders),
            ("testHTTPRequestTwoHeadersOptionalSpaces", testHTTPRequestTwoHeadersOptionalSpaces),
            ("testInvalidHeaderColon", testInvalidHeaderColon),
            ("testInvalidHeaderName", testInvalidHeaderName),
            ("testInvalidHeaderEnd", testInvalidHeaderEnd),
            ("testHeaderName", testHeaderName),
            ("testUnexpectedEnd", testUnexpectedEnd),
            ("testContentLenght", testContentLenght),
            ("testKeepAliveFalse", testKeepAliveFalse),
            ("testKeepAliveTrue", testKeepAliveTrue),
            ("testTransferEncodingChunked", testTransferEncodingChunked),
            ("testChunkedBody", testChunkedBody),
            ("testChunkedBodyInvalidSizeSeparator", testChunkedBodyInvalidSizeSeparator),
            ("testChunkedBodyNoSizeSeparator", testChunkedBodyNoSizeSeparator),
            ("testChunkedInvalidBody", testChunkedInvalidBody),
            ("testChunkedJunkAfterBody", testChunkedJunkAfterBody),
            ("testPreformanceLite", testPreformanceLite),
            ("testPreformanceChunkedBody", testPreformanceChunkedBody),
            ("testPreformanceFull", testPreformanceFull),
        ]
    }
}
