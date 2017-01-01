/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

import Foundation

public struct URLParamMatcher {
    let params: [(name: String, index: Int)]
    public init(_ url: String) {
        let components = url.components(separatedBy: "/")
        var params: [(name: String, index: Int)] = []
        for (index, item) in components.enumerated() {
            if item.hasPrefix(":") {
                let name = item.substring(from: item.index(after: item.startIndex))
                params.append((name, index))
            }
        }
        self.params = params
    }

    public func values(from url: String) -> [String : String] {
        var dictionary: [String : String] = [:]

        let unicode = url.unicodeScalars
        var startIndex = unicode.index(after: unicode.startIndex)
        var endIndex = unicode.index(after: startIndex)

        var current = 1
        for param in params {
            while true {
                while endIndex < unicode.endIndex && unicode[endIndex] != "/" {
                    endIndex = unicode.index(after: endIndex)
                }
                if current == param.index {
                    dictionary[param.name] = String(unicode[startIndex..<endIndex])
                }
                guard endIndex != unicode.endIndex else {
                    break
                }
                startIndex = unicode.index(after: endIndex)
                endIndex = unicode.index(after: startIndex)
                current += 1
            }
        }
        return dictionary
    }
}
