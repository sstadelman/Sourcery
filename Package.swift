// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Sourcery",
    platforms: [
       .macOS(.v10_15),
    ],
    products: [
        .executable(name: "sourcery", targets: ["Sourcery"]),
        .library(name: "SourceryRuntime", targets: ["SourceryRuntime"]),
        .library(name: "SourceryJS", targets: ["SourceryJS"]),
        .library(name: "SourcerySwift", targets: ["SourcerySwift"]),
        .library(name: "SourceryFramework", targets: ["SourceryFramework"]),
        .library(name: "SourceryTestSupport", targets: ["SourceryTestSupport"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kylef/Commander.git", .exact("0.9.1")),
        // PathKit needs to be exact to avoid a SwiftPM bug where dependency resolution takes a very long time.
        .package(url: "https://github.com/kylef/PathKit.git", .exact("0.9.2")),
        .package(url: "https://github.com/jpsim/SourceKitten.git", .exact("0.30.1")),
        .package(url: "https://github.com/SwiftGen/StencilSwiftKit.git", .exact("2.7.0")),
        .package(name: "xcproj", url: "https://github.com/tuist/xcodeproj", .exact("4.3.1")),
        .package(url: "https://github.com/apple/swift-tools-support-core.git", .revision("a2d779aed8fff8afd4153a13c4a4ef530edea1a7"))
    ],
    targets: [
        .target(name: "Sourcery", dependencies: [
            "SourceryFramework",
            "SourceryRuntime",
            "SourceryJS",
            "SourcerySwift",
            "Commander",
            "PathKit",
            .product(name: "SourceKittenFramework", package: "SourceKitten"),
            "StencilSwiftKit",
            "xcproj",
            "TryCatch",
        ]),
        .target(name: "SourceryRuntime"),
        .target(name: "SourceryUtils", dependencies: [
          "PathKit"
        ]),
        .target(name: "SourceryFramework", dependencies: [
            "PathKit",
            .product(name: "SourceKittenFramework", package: "SourceKitten"),
            "SourceryUtils",
            "SourceryRuntime"
        ]),
        .target(name: "SourceryJS", dependencies: [
          "PathKit"
        ]),
        .target(name: "SourcerySwift", dependencies: [
          "PathKit",
          "SourceryRuntime",
          "SourceryUtils"
        ]),
        .target(name: "TryCatch", path: "TryCatch"),
        .target(name: "SourceryTestSupport", dependencies: [
            "Sourcery"
        ]),
        .testTarget(name: "SourceryUtilsTests",
                    dependencies: [
                        .target(name: "SourceryTestSupport"),
                        "SourceryUtils",
                        .product(name: "TSCTestSupport", package: "swift-tools-support-core")
                    ],
                    resources: [
                        .copy("TestCase.zip")
                    ])
    ]
)
