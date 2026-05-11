// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "HDXLSIMDSupport",
  platforms: [
    .iOS(.v26),
    .macOS(.v26),
    .tvOS(.v26),
    .watchOS(.v26),
    .visionOS(.v26),
    .macCatalyst(.v26)
  ],
  products: [
    .library(
      name: "HDXLSIMDSupport",
      targets: ["HDXLSIMDSupport"]
    )
  ],
  dependencies: [
  ],
  targets: [
    .target(
      name: "HDXLSIMDSupport",
      dependencies: []
    ),
    .testTarget(
      name: "HDXLSIMDSupportTests",
      dependencies: ["HDXLSIMDSupport"]
    )
  ],
  swiftLanguageModes: [
    .v6
  ]
)
