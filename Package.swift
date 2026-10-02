// swift-tools-version:6.3
import PackageDescription
let package = Package(name: "MiniClang", platforms: [.macOS(.v15), .iOS(.v18)],
    products: [.library(name: "MiniClang", targets: ["MiniClang"]), .executable(name: "mini-clang", targets: ["MiniClangCLI"])],
    // Compile the pinned vendored runtime directly so remote package resolution works.
    traits: [.default(enabledTraits: ["FileSystem", "MultiThread"]), "FileSystem", "MultiThread"],
    targets: [
        .target(name: "WasmTypes", path: "Vendor/WasmKit/Sources/WasmTypes", exclude: ["CMakeLists.txt"]),
        .target(name: "WasmParser", dependencies: ["WasmTypes"], path: "Vendor/WasmKit/Sources/WasmParser", exclude: ["CMakeLists.txt"]),
        .target(name: "_CWasmKit", path: "Vendor/WasmKit/Sources/_CWasmKit", exclude: ["CMakeLists.txt"]),
        .target(name: "WasmKit", dependencies: ["_CWasmKit", "WasmParser", "WasmTypes"], path: "Vendor/WasmKit/Sources/WasmKit", exclude: ["CMakeLists.txt"], swiftSettings: [.enableExperimentalFeature("RawLayout")]),
        .target(name: "WASI", dependencies: ["WasmTypes"], path: "Vendor/WasmKit/Sources/WASI", exclude: ["CMakeLists.txt"]),
        .target(name: "WasmKitWASI", dependencies: ["WasmKit", "WASI"], path: "Vendor/WasmKit/Sources/WasmKitWASI", exclude: ["CMakeLists.txt"]),
        .target(name: "CompilerBridge", publicHeadersPath: "include"),
        .target(name: "MiniClang", dependencies: ["CompilerBridge", "WasmKit", "WasmKitWASI", "WASI"]),
        .executableTarget(name: "MiniClangCLI", dependencies: ["MiniClang"]),
        .testTarget(name: "MiniClangTests", dependencies: ["MiniClang"], resources: [.copy("Fixtures")])
    ], swiftLanguageModes: [.v5])
