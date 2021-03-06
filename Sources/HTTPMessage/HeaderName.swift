/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

struct HeaderName: Hashable {
    static let host = HeaderName("host")
    static let userAgent = HeaderName("user-agent")
    static let accept = HeaderName("accept")
    static let acceptLanguage = HeaderName("accept-language")
    static let acceptEncoding = HeaderName("accept-encoding")
    static let acceptCharset = HeaderName("accept-charset")
    static let keepAlive = HeaderName("keep-alive")
    static let connection = HeaderName("connection")
    static let contentLength = HeaderName("content-length")
    static let transferEncoding = HeaderName("transfer-encoding")

    let name: ArraySlice<UInt8>
    init(validatingCharacters bytes: ArraySlice<UInt8>) throws {
        for byte in bytes {
            guard Int(byte) < tokens.count && tokens[Int(byte)] else {
                throw HTTPRequestError.invalidHeaderName
            }
        }
        name = bytes
    }
    fileprivate init(_ value: String) {
        name = ArraySlice<UInt8>(value.utf8)
    }
    var hashValue: Int {
        var hash = 5381
        for byte in name {
            hash = ((hash << 5) &+ hash) &+ Int(byte | 0x20)
        }
        return hash
    }
}

extension HeaderName: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        self.init(value)
    }
    init(extendedGraphemeClusterLiteral value: String) {
        self.init(value)
    }
    init(unicodeScalarLiteral value: String) {
        self.init(value)
    }
}

func == (lhs: HeaderName, rhs: HeaderName) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
