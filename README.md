# MiniClang
Standalone Swift package for offline C99/C++11 compilation to WebAssembly and execution through WasmKit. Supports iOS 18+ and macOS 15+ with Swift 6.3+. C++ exceptions are unsupported.

### AI DIsclosure
This library was made wholly by AI (Codex). It was made for use in [Mini C](https://github.com/somebud0180/minic) as its compiler. As such this library is provided as-is and was made into a repository to neatly integrate in the development chain along with making the code visible. Thank you!

## Development
The package compiles pinned WasmKit sources directly as targets, with no local package dependency, and includes runtime test fixtures, so package resolution and runtime tests do not need the compiler downloads:

```sh
swift test
swift build --product mini-clang
```

Download and verify the iOS compiler frameworks and WASI sysroot before embedding into an app:

```sh
swift Tools/bootstrap-offline-clang.swift
```

The bootstrap requires network access; the installed app runs offline. Archives, extracted toolchain binaries, personal Xcode settings, and build caches are ignored by Git. Third-party notices are in `Licenses/` and `Vendor/WasmKit/LICENSE`.

Desktop compilation tests require a compatible desktop WASI SDK:

```sh
MINIC_WASI_SDK=/path/to/wasi-sdk MINIC_SYSROOT="$PWD/Vendor/usr" swift test
```

## Importing into an iOS app
Add `https://github.com/somebud0180/miniclang.git` as a remote Swift package in Xcode and link the `MiniClang` product. Use `import MiniClang` in Swift. A local checkout also works for library development.

The Swift package supplies the compiler bridge and runtime. The dynamically loaded compiler frameworks and filesystem sysroot additionally require an app build phase:

1. Define `OFFLINE_CLANG_ROOT` as the absolute package checkout path (Mini C uses `$(BUILD_DIR)/../../SourcePackages/checkouts/miniclang`).
2. Run `"$OFFLINE_CLANG_ROOT/Tools/embed-offline-clang.sh"` before app signing.
3. If build-script sandboxing is enabled, use `$(OFFLINE_CLANG_ROOT)/Vendor/inputs.xcfilelist` as an input file list, and declare the toolchain resource and Frameworks directories as outputs.
4. Set the executable runpath to `@executable_path/Frameworks` and export `_MCCompilerEntry` and `_main` through linker flags, as Mini C does.

The embedding script uses Xcode's target build directory, resource directory, framework directory, architecture, platform and signing environment variables. It embeds only the selected framework slice. Physical iPhones and Intel simulators support compilation; ARM simulators support bundled WebAssembly runtime examples only.

Remote package resolution uses the pinned vendored runtime without fetching additional dependencies. The app must still bootstrap the toolchain and point `OFFLINE_CLANG_ROOT` at that checkout for its embedding phase.
