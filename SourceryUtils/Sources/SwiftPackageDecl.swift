//
//  SwiftPackage.swift
//  Sourcery
//
//  Created by Stadelman, Stan on 12/14/20.
//  Copyright © 2020 Pixle. All rights reserved.
//

import Foundation
public struct SwiftPackageDecl: Equatable {

    public let package: String
    public let repositoryURL: URL
    public let state: State
    public let products: [String]

    public init(name: String, dict: [String: Any]) throws {
        self.package = name

        if let path = dict["path"] as? String {
            self.repositoryURL = URL(fileURLWithPath: path)
            self.state = .local
        } else if let url = dict["url"] as? String {
            guard let validURL = URL(string: url) else { throw Error.invalidURL(url) }
            self.repositoryURL = validURL
            self.state = try State(dict: dict)
        } else {
            throw Error.missingURLorPath
        }
        
        if let products = dict["products"] as? [String] {
            self.products = products
        } else if let product = dict["product"] as? String {
            self.products = [product]
        } else {
            self.products = [package]
        }
    }

    public var dependencyDescription: String {
        nameAndLocation + spacer + state.description + ")"
    }
    
    public var productsDescriptions: [String] {
        products.map { ".product(name: \($0.quoted), package: \(package.quoted))" }
    }
}

fileprivate extension SwiftPackageDecl {
    
    var nameAndLocation: String {
        ".package(name: \"\(package)\", \(self.state == .local ? "path" : "url"): \"\(location)\""
    }
    
    var spacer: String {
        self.state == .local ? "" : ", "
    }
    
    var location: String {
        return self.state == .local ? repositoryURL.relativePath : repositoryURL.absoluteString
    }
    
    var includesSourceryRuntime: Bool {
        return products.contains("SourceryRuntime")
    }
}

public extension Array where Element == SwiftPackageDecl {
    var includesSourceryRuntime: Bool {
        first(where: { $0.includesSourceryRuntime }) != nil
    }
}

extension SwiftPackageDecl {
    public enum State {
        case branch(String)
        case revision(String)
        case exact(String)
        case from(String)
        case nextMajor(String)
        case nextMinor(String)
        case range(String, String)
        case local
        
        init(dict: [String: Any]) throws {
            print(dict)
            
            if let x = dict["exactVersion"] as? String {
                self = .exact(x)
            } else if let x = dict["version"] as? String {
                self = .exact(x)
            } else if let x = dict["revision"] as? String {
                self = .revision(x)
            } else if let x = dict["from"] as? String {
                self = .from(x)
            } else if let x = dict["majorVersion"] as? String {
                self = .nextMajor(x)
            } else if let x = dict["minorVersion"] as? String {
                self = .nextMinor(x)
            } else if let x = dict["minVersion"] as? String {
                if let y = dict["maxVersion"] as? String {
                    self = .range(x, y)
                } else {
                    self = .from(x)
                }
            } else if let x = dict["branch"] as? String {
                throw Error.branchRequirementIsNotSupported(x)
            } else {
                throw Error.invalidRequirement(dict)
            }
        }
        
        var description: String {
            switch self {
                case .branch(let x):
                    return ".branch(\(x.quoted))"
                case .exact(let x):
                    return ".exact(\(x.quoted))"
                case .revision(let x):
                    return ".revision(\(x.quoted))"
                case .from(let x):
                    return "from: \(x.quoted)"
                case .nextMajor(let x):
                    return ".upToNextMajor(from: \(x.quoted))"
                case .nextMinor(let x):
                    return ".upToNextMinor(from: \(x.quoted))"
                case .range(let x, let y):
                    return "\(x.quoted)...\(y.quoted)"
                case .local:
                    return ""
            }
        }
    }
}

extension SwiftPackageDecl {
    public enum Error: Swift.Error {
        case missingURLorPath
        case invalidURL(String)
        case invalidRequirement([String: Any])
        case branchRequirementIsNotSupported(String)
        
        var localizedDescription: String {
            switch self {
                case .branchRequirementIsNotSupported(let x):
                    return """
`branch` requirement is not supported for Package dependency \(x).
Use `path` to read locally, or specify a version or range requirement
to consume from remote.
"""
                default:
                    return String(describing: self)
            }
        }
    }
}

fileprivate extension String {
    var quoted: String {
        """
"\(self)"
"""
    }
}

extension SwiftPackageDecl.State: Equatable {
    public static func == (lhs: SwiftPackageDecl.State, rhs: SwiftPackageDecl.State) -> Bool {
        switch (lhs, rhs) {
            case (.local, .local):
                return true
            case (.branch(let x), .branch(let y)):
                return x == y
            case (.revision(let x), .revision(let y)):
                return x == y
            case (.from(let x), .from(let y)):
                return x == y
            case (.exact(let x), .exact(let y)):
                return x == y
            case (.nextMajor(let x), .nextMajor(let y)):
                return x == y
            case (.nextMinor(let x), .nextMinor(let y)):
                return x == y
            case (.range(let w, let x), .range(let y, let z)):
                return w == y && x == z
            default:
                return false
        }
    }
}


