// swift-tools-version:6.3
import PackageDescription
let package = Package(name: "MiniClang", platforms: [.macOS(.v15), .iOS(.v18)],
    products: [.library(name: "MiniClang", targets: ["MiniClang"]), .executable(name: "mini-clang", targets: ["MiniClangCLI"])],
    dependencies: [.package(path: "Vendor/WasmKit")],
    targets: [
        .target(name: "CompilerBridge", publicHeadersPath: "include"),
        .target(name: "MiniClang", dependencies: ["CompilerBridge", .product(name: "WasmKit", package: "WasmKit"), .product(name: "WasmKitWASI", package: "WasmKit"), .product(name: "WASI", package: "WasmKit")]),
        .executableTarget(name: "MiniClangCLI", dependencies: ["MiniClang"]),
        .testTarget(name: "MiniClangTests", dependencies: ["MiniClang"], resources: [.copy("Fixtures")])
    ], swiftLanguageModes: [.v5])
