// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Printerceptor",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(name: "Printerceptor", targets: ["Printerceptor"]),
    ],
    targets: [
        .target(name: "Printerceptor"),
        .testTarget(name: "PrinterceptorTests", dependencies: ["Printerceptor"]),
    ]
)
