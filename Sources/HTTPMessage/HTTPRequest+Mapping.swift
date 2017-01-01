/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

extension HTTPRequestType {
    init(slice: ArraySlice<UInt8>) throws {
        for (type, bytes) in RequestTypeMapping.values {
            if slice.elementsEqual(bytes) {
                self = type
                return
            }
        }
        throw HTTPRequestError.invalidMethod
    }
}

fileprivate struct RequestTypeMapping {
    static let values: [(HTTPRequestType, ASCII)] = [
        (.get, ASCII("GET")),
        (.head, ASCII("HEAD")),
        (.post, ASCII("POST")),
        (.put, ASCII("PUT")),
        (.delete, ASCII("DELETE"))
    ]
}
