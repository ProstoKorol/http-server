/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

public enum HTTPVersion {
    case oneOne
}

extension HTTPVersion {
    init(slice: ArraySlice<UInt8>) throws {
        guard slice.starts(with: HTTPConstants.httpSlash) else {
            throw HTTPRequestError.invalidVersion
        }
        let versionStart = slice.startIndex.advanced(by: HTTPConstants.httpSlash.count)
        let versionEnd = slice.index(versionStart, offsetBy: 3)
        let versionSlice = slice[versionStart..<versionEnd]
        if versionSlice.elementsEqual(HTTPConstants.oneOne) {
            self = .oneOne
        } else {
            throw HTTPRequestError.invalidVersion
        }
    }

    var bytes: [UInt8] {
        switch self {
        case .oneOne:
            return HTTPConstants.oneOne
        }
    }
}
