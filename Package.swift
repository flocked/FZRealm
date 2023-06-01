// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "FZRealm",
    platforms: [
        .macOS("10.15.1"), .iOS(.v14),
    ],
    products: [
        .library(name: "FZRealm", targets: ["FZRealm"]),
    ],
    dependencies: [
        .package(url: "https://github.com/flocked/FZSwiftUtils.git", branch: "main"),
        .package(url: "https://github.com/flocked/FZUIKit.git", branch: "main"),
        .package(name: "Realm", url: "https://github.com/realm/realm-cocoa", .upToNextMajor(from: "10.0.0"))
    ],
    targets: [
        .target(
            name: "FZRealm",
            dependencies: [
                .product(name: "FZSwiftUtils", package: "FZSwiftUtils"),
                .product(name: "FZUIKit", package: "FZUIKit"),
                .product(name: "Realm", package: "Realm"),
                .product(name: "RealmSwift", package: "Realm"),
            ]
        ),
    ]
)
