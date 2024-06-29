// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let macroPluginDependencies: [Target.Dependency] = [
  .product(
    name: "SwiftSyntax",
    package: "swift-syntax"
  ),
  .product(
    name: "SwiftParser",
    package: "swift-syntax"
  ),
  .product(
    name: "SwiftSyntaxBuilder",
    package: "swift-syntax"
  ),
  .product(
    name: "SwiftSyntaxMacros",
    package: "swift-syntax"
  ),
  .product(
    name: "SwiftCompilerPlugin",
    package: "swift-syntax"
  ),
  .product(
    name: "SwiftDiagnostics",
    package: "swift-syntax"
  )
]

let macroLibraryDependencies: [Target.Dependency] = [
  .product(
    name: "SwiftSyntax",
    package: "swift-syntax"
  ),
  .product(
    name: "SwiftParser",
    package: "swift-syntax"
  ),
  .product(
    name: "SwiftSyntaxBuilder",
    package: "swift-syntax"
  ),
  .product(
    name: "SwiftSyntaxMacros",
    package: "swift-syntax"
  ),
  .product(
    name: "SwiftDiagnostics",
    package: "swift-syntax"
  )
]

let macroSupportDependencies: [Target.Dependency] = [
  .product(
    name: "SwiftSyntax",
    package: "swift-syntax"
  ),
  .product(
    name: "SwiftParser",
    package: "swift-syntax"
  ),
  .product(
    name: "SwiftSyntaxBuilder",
    package: "swift-syntax"
  ),
  .product(
    name: "SwiftSyntaxMacros",
    package: "swift-syntax"
  ),
  .product(
    name: "SwiftDiagnostics",
    package: "swift-syntax"
  )
]

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
    ),
    .library(
      name: "HDXLSIMDSupportMacros",
      targets: ["HDXLSIMDSupportMacros"]
    )
  ],
  dependencies: [
    .package(
      url: "https://github.com/apple/swift-docc-plugin",
      from: "1.3.0"
    ),
    .package(
      url: "https://github.com/apple/swift-syntax.git",
      from: "510.0.0"
    ),
  ],
  targets: [
    .target(
      name: "HDXLSIMDSupport",
      dependencies: [
        "HDXLSIMDSupportMacros",
        "HDXLSIMDSupportProtocols"
      ]
    ),
    .target(
      name: "HDXLSIMDSupportProtocols",
      dependencies: []
    ),
    .target(
      name: "HDXLSIMDSupportProtocolsTestSupport",
      dependencies: ["HDXLSIMDSupportProtocols"]
    ),
    .target(
      name: "HDXLSIMDSupportMacros",
      dependencies: [
        "HDXLSIMDSupportMacrosPlugin",
        "HDXLSIMDSupportProtocols"
      ] + macroLibraryDependencies
    ),
    .macro(
      name: "HDXLSIMDSupportMacrosPlugin",
      dependencies: [
        "HDXLSIMDSupportProtocols"
      ] + macroPluginDependencies
    ),
    .testTarget(
      name: "HDXLSIMDSupportTests",
      dependencies: [
        "HDXLSIMDSupport",
        "HDXLSIMDSupportProtocolsTestSupport"
      ]
    ),
    .testTarget(
      name: "HDXLSIMDSupportProtocolsTests",
      dependencies: [
        "HDXLSIMDSupportProtocols",
        "HDXLSIMDSupportProtocolsTestSupport"
      ]
    ),
    .testTarget(
      name: "HDXLSIMDSupportMacrosTests",
      dependencies: [
        "HDXLSIMDSupportProtocols",
        "HDXLSIMDSupportMacrosPlugin"
      ]
    ),
  ],
  swiftLanguageVersions: [
    .v6
  ]
)

