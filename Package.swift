// swift-tools-version:6.0

import PackageDescription

let package = Package(
  name: "portfolio",
  platforms: [
    .macOS(.v13),
  ],
  products: [
    .library(name: "ActivityClient", targets: ["ActivityClient"]),
    .library(name: "Reactive", targets: ["Reactive"]),
    .library(name: "SyntaxHighlight", targets: ["SyntaxHighlight"]),
    .library(name: "Models", targets: ["Models"]),
    .library(name: "Routes", targets: ["Routes"]),
    .library(name: "Pages", targets: ["Pages"]),
    .executable(name: "App", targets: ["App"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.4.0"),
    .package(url: "https://github.com/hummingbird-project/hummingbird.git", exact: "2.5.0"),
    .package(url: "https://github.com/sliemeobn/elementary.git", exact: "0.4.3"),
    .package(url: "https://github.com/pointfreeco/swift-url-routing.git", exact: "0.6.2"),
    .package(url: "https://github.com/pointfreeco/swift-dependencies.git", exact: "1.6.2"),
    .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.1"),
    .package(url: "https://github.com/errorerrorerror/swift-cascadia", revision: "7ecd4f55648087446d194aa07ba0cfbc5e7461a6")
  ],
  targets: [
    .target(
      name: "Models",
      dependencies: [
        .product(name: "Dependencies", package: "swift-dependencies"),
      ]
    ),
    .target(
      name: "Routes",
      dependencies: [
        "Models",
        "ActivityClient",
        .product(name: "Dependencies", package: "swift-dependencies"),
        .product(name: "URLRouting", package: "swift-url-routing"),
        .product(name: "Hummingbird", package: "hummingbird"),
        .product(name: "HummingbirdRouter", package: "hummingbird"),
      ]
    ),
    .target(
      name: "Pages",
      dependencies: [
        "Reactive",
        "Models",
        "SyntaxHighlight",
        "ActivityClient",
        .product(name: "Dependencies", package: "swift-dependencies"),
        .product(name: "Elementary", package: "elementary"),
        .product(name: "Hummingbird", package: "hummingbird"),
        .product(name: "Cascadia", package: "swift-cascadia")
      ]
    ),

    /// Clients
    .target(
      name: "ActivityClient",
      dependencies: [
        .product(name: "Dependencies", package: "swift-dependencies"),
        .product(name: "DependenciesMacros", package: "swift-dependencies"),
      ]
    ),

    /// Misc
    .target(
      name: "SyntaxHighlight",
      dependencies: [
        .product(name: "Elementary", package: "elementary"),
        .product(name: "SwiftSyntax", package: "swift-syntax"),
        .product(name: "SwiftParser", package: "swift-syntax"),
      ]
    ),
    .target(name: "Reactive"),

    /// Executable
    .executableTarget(
      name: "App",
      dependencies: [
        "Models",
        "Routes",
        "Pages",
        "ActivityClient",
        .product(name: "Dependencies", package: "swift-dependencies"),
        .product(name: "Hummingbird", package: "hummingbird"),
        .product(name: "HummingbirdRouter", package: "hummingbird"),
        .product(name: "ArgumentParser", package: "swift-argument-parser")
      ],
      resources: [.embedInCode("Resources")]
    ),
  ],
  swiftLanguageModes: [.v6]
)

package.targets
  .filter { $0.type != .binary }
  .forEach {
    $0.swiftSettings = [
      .unsafeFlags([
        "-Xfrontend",
        "-warn-long-function-bodies=100",
        "-Xfrontend",
        "-warn-long-expression-type-checking=100"
      ])
    ]
  }