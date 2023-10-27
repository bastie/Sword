# KnightLife package



## Package.swift example
```
// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Moonlight",
    products: [
        .executable(name: "Moonlight", targets: ["Moonlight"]),
    ],
    dependencies: [
        .package(url: "https://github.com/bastie/egg.git", .upToNextMajor(from: "0.6.0")),
    ],
    targets: [
        .executableTarget(
            name: "Moonlight",
            dependencies: [
                .product(name: "KnightLife", package: "egg"),
            ]),
    ]
)
```
