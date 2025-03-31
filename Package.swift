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
    dependencies: [
        .package(url: "https://github.com/longitachi/ZLPhotoBrowser", .upToNextMinor(from: "4.5.8")),
        .package(url: "https://github.com/SnapKit/SnapKit", .upToNextMinor(from: "5.7.1")),
        
    ],
    targets: [
        .target(
            name: "CHPictureEditTools",
            path: "CHPictureEditTools/Sources"
        ),
    ]
)
