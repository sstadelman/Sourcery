//
//  File.swift
//  
//
//  Created by Stadelman, Stan on 1/8/21.
//

import Foundation
import XCTest
import TSCBasic
import TSCTestSupport
import TSCUtility
import PathKit
@testable import SourceryTestSupport

class SwiftPackageDeclTests: XCTestCase {
    
    func testExample() throws {
        _ = "machine protected.downloader-tests.com login anonymous password qwerty"

        let authData = "anonymous:qwerty".data(using: .utf8)!
        _ = "Basic \(authData.base64EncodedString())"
        
        let yml = """
        sources:
          - ./../Sources/FioriSwiftUICore/Components/
          - ./../Sources/FioriSwiftUICore/Models/
          - ./../Sources/FioriSwiftUICore/_generated/Components/
        templates:
          - ./../sourcery/stencils/main_phase/model_decl_base.swifttemplate
        output:
          swift_gen_temp/
        args:
          prune: true
        force-parse:
          - generated
        packages:
          cloud_sdk_ios_sourcery_utils:
            url: https://github.com/sstadelman/cloud-sdk-ios-sourcery-utils.git
            branch: main
            exactVersion: xxxx
            version: "0.0.1"
            revision: xxxx
            from: xxxx
            majorVersion: xxxx
            minorVersion: xxx
            minVersion: xxxx
            maxVersion: xxxx
        """
        
        guard let url = Bundle.module.url(forResource: "TestCase", withExtension: "zip") else { XCTFail(); return }
        
        let successExpectation = XCTestExpectation(description: "success")
    
        try testWithTemporaryDirectory { tmpdir in
            
            let destinationDir = tmpdir.appending(RelativePath("TestCase"))
            print(destinationDir.pathString)
            try localFileSystem.createDirectory(destinationDir)
            let zipArchiver = ZipArchiver(fileSystem: localFileSystem)
            zipArchiver.extract(from: AbsolutePath(url.path), to: destinationDir) { result in
                switch result {
                    case .success:
                        do {
                  
                            successExpectation.fulfill()
                        } catch {
                            XCTFail(String(describing: error))
                            
                        }
                        break
                    case .failure(let error):
                        XCTFail(String(describing: error))
                }
            }
            
            wait(for: [successExpectation], timeout: 10.0)
            
//            let packageDir = tmpdir.appending(component: "foo")
//            let packageSwiftPath = packageDir.appending(component: "Package.swift").pathString
//            try Content.package.write(toFile: packageSwiftPath, atomically: true, encoding: .utf8)
//
//            let fooDir = packageDir.appending(components: "Sources", "Foo")
//            let sourceSwiftPath = fooDir.appending(component: "A.swift").pathString
//            try Content.source.write(toFile: sourceSwiftPath, atomically: true, encoding: .utf8)
//
//            let ymlPath = packageDir.appending(component: "config.yml").pathString
//            try yml.write(toFile: ymlPath, atomically: true, encoding: .utf8)
            
            
            

        }
        
//        try testWithTemporaryDirectory { tmpdir in
//            let url = URL(string: "https://protected.downloader-tests.com/testBasics.zip")!
//            let destination = tmpdir.appending(component: "download")
//
//            let didStartLoadingExpectation = XCTestExpectation(description: "didStartLoading")
//
//
//            wait(for: [didStartLoadingExpectation], timeout: 1.0)
//
//            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "1.1", headerFields: [
//                "Content-Length": "1024"
//            ])!
//
//        }
    }
    
    
    struct Content {
        static let source =
            """
    protocol B {
        var value: Int { get }
    }

    struct A: B {
        var value: Int { 0 }
    }
    """
        
        static let swifttemplate =
            """
    <%_
    let values: [A] = [0, 1, 1, 2, 3, 5, 8, 13, 21].map { A(value: $0) }
    -%>
    <%= values.value %>
    """
        
        static let package =
            """
    // swift-tools-version:5.3
    // The swift-tools-version declares the minimum version of Swift required to build this package.

    import PackageDescription

    let package = Package(
        name: "CustomPackage",
        platforms: [.macOS(.v10_15)],
        products: [
            .library(
                name: "Custom",
                type: .dynamic,
                targets: ["utils"]),
        ],
        dependencies: [
            .package(name: "dealer",
                     url: "https://github.com/apple/example-package-dealer.git",
                     .exact("2.0.0"))
        ],
        targets: [
            .target(
                name: "utils",
                dependencies: [.product(name: "Dealer", package: "dealer")])
        ]
    )
    """
    }
    
    
}
