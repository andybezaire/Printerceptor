# Printerceptor ![license MIT](https://img.shields.io/github/license/andybezaire/Printerceptor)

You are now leveled up to verify your application output using *Swift Testing automated tests*. 🚀


## Overview

Verifying the output of your command line tool can be laborious, tedious, and sometimes tricky.  It might be hard to reproduce some edge cases, meaning that you either skip those tests, or perform testing less often. This can lead to wider problems.

`Printerceptor` was designed with these problems in mind.
Now you can forget about those laborious manual tests. Printerceptor allows you to capture your program output and verify so it is as you `#expect`.

🫵😎🎉


## Sample Use

```swift
import Testing

@Suite(.serialized)
struct ExampleTests {
    @Test func helloWorld() async throws {
        let capturedOutput = interceptStdout {
            print("Hello, World!")
        }

        #expect(capturedOutput == "Hello, World!")
    }
}
```


## Installation

### Xcode Project
 
Add this package as a dependency to the test target of your Xcode project.

1. Xcode Menu > File > Add Packages...
1. Paste this project's URL to the "Search or Enter Package URL" field. (https://github.com/andybezaire/Printerceptor)
1. Select `Printerceptor` product and add it to your project's **test target** Note: **NOT your main target.**
1. Press "Add Package" button.

### Swift Package Manager (SPM)

Add this package as a dependency to the **test target** of your Swift package. 

```swift
// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SampleProduct",
    products: [
        .library(name: "SampleProduct", targets: ["SampleProduct"])
    ],
    dependencies: [
        .package(name: "Printerceptor", url: "https://github.com/andybezaire/Printerceptor.git", from: "1.0.0")
    ],
    targets: [
        .target(name: "SampleProduct", dependencies: []),
        .testTarget(name: "SampleProductTests", dependencies: ["SampleProduct", "Printerceptor"])
    ]
)
```


## More Info and Feature Requests

Please do not hesitate to open a [GitHub issue](https://github.com/andybezaire/Printerceptor/issues) 
for any questions or feature requests.  


## License

"TDDKit" is available under the MIT license. 
See the [LICENSE](https://github.com/andybezaire/Printerceptor/blob/main/LICENSE) file for more info.


## Credit

Copyright (c) 2024 Andy Bezaire

Created by: andybezaire
