/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

struct HeaderNameMapping {
    static let contentType = ASCII("Content-Type")
    static let contentLength = ASCII("Content-Length")
    static let transferEncoding = ASCII("Transfer-Encoding")
}

extension HTTPResponseStatus {
    private struct StatusCodeMapping {
        static let ok = ASCII("200 OK")
        static let moved = ASCII("301 Moved Permanently")
        static let badRequest = ASCII("400 Bad Request")
        static let unauthorized = ASCII("401 Unauthorized")
        static let notFound = ASCII("404 Not Found")
        static let internalServerError = ASCII("500 Internal Server Error")
    }

    var bytes: [UInt8] {
        switch self {
        case .ok: return StatusCodeMapping.ok
        case .moved: return StatusCodeMapping.moved
        case .badRequest: return StatusCodeMapping.badRequest
        case .unauthorized: return StatusCodeMapping.unauthorized
        case .notFound: return StatusCodeMapping.notFound
        case .internalServerError: return StatusCodeMapping.internalServerError
        }
    }
}

extension HTTPResponseContentType {
    private struct StatusCodeMapping {
        static let text = ASCII("text/plain")
        static let html = ASCII("text/html")
        static let stream = ASCII("aplication/stream")
        static let json = ASCII("application/json")
    }
    var bytes: [UInt8] {
        switch self {
        case .text: return StatusCodeMapping.text
        case .html: return StatusCodeMapping.html
        case .stream: return StatusCodeMapping.stream
        case .json: return StatusCodeMapping.json
        }
    }
}
