// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "foo",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(
            name: "Foo",
            type: .dynamic,
            targets: ["Foo"]),
    ],
    dependencies: [
        .package(name: "DeckOfPlayingCards", url: "https://github.com/apple/example-package-deckofplayingcards.git", from: "3.0.0"),
        .package(name: "Sourcery", url: "https://github.com/krzysztofzablocki/Sourcery.git", .exact("1.0.2"))
    ],
    targets: [
        .target(
            name: "Foo",
            dependencies: ["DeckOfPlayingCards",
                           .product(name: "SourceryRuntime", package: "Sourcery")]),
        .testTarget(name: "FooTests",
                    dependencies: ["Foo"])
    ]
)
