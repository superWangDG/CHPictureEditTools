// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CHPictureEditTools",
    platforms: [
        .iOS(.v13) // 最低支持的版本
    ],
    products: [
        .library(
            name: "CHPictureEditTools",
            targets: ["CHPictureEditTools"]),
    ],
    targets: [
        .target(
            name: "CHPictureEditTools",
            path: "CHPictureEditTools/Sources"
        ),
    ]
)
