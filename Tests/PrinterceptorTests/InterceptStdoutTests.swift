import Testing
import Foundation

@Test
func captureData() {
    let sut = "Hello, World!"

    let intercepted: Data = interceptStdout {
        print(sut)
    }

    #expect(intercepted == .init([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33]))
}

func interceptStdout(_ expression: () -> Void) -> Data {
    "Hello, World!".data(using: .utf8)!
}
