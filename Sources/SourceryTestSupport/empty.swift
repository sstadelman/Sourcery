//
//  File.swift
//  
//
//  Created by Stadelman, Stan on 1/12/21.
//

import Foundation
import PathKit
@testable import sourcery

extension Configuration {
    public init(
        path: Path,
        relativePath: Path
    ) throws {
        try self.init(path: path, relativePath: relativePath, env: [:])
    }
}
