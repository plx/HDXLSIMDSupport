// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "HDXLSIMDSupport",
  platforms: [
    .iOS(.v18),
    .macOS(.v15),
    .tvOS(.v18),
    .watchOS(.v11)
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
  swiftLanguageVersions: [
    .v6
  ]
)

