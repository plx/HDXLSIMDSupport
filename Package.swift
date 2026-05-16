// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

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
    .package(
      url: "https://github.com/swiftlang/swift-syntax.git",
      from: "603.0.1"
    )
  ],
  targets: [
    .macro(
      name: "HDXLSIMDSupportMacroPlugin",
      dependencies: [
        .product(name: "SwiftSyntax", package: "swift-syntax"),
        .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
      ]
    ),
    .target(
      name: "HDXLSIMDSupport",
      dependencies: ["HDXLSIMDSupportMacroPlugin"]
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
