import Testing
import Printerceptor
import Foundation

@Suite(.serialized)
struct PrinterceptorTests {
    @Test
    func determineFunctionSignature() async throws {
        let sut = "Hello, World!"

        let captured: String = interceptStdout {
            print(sut)
        }

        #expect(captured == "Hello, World!")
    }

    @Test @MainActor
    func captureData() async throws {
        let sut = "Hello, World!"

        let intercepted: Data = try await interceptStdout {
            print(sut)
        }

        #expect(intercepted == .init([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33, 10]))
    }
}

@MainActor
func interceptStdout(_ expression: () -> Void) async throws -> Data {
    let intercepted = Pipe()

    dup2(
        intercepted.fileHandleForWriting.fileDescriptor,
        FileHandle.standardOutput.fileDescriptor
    )

    var data: Data = Data()

    intercepted.fileHandleForReading.readabilityHandler = {
        let availableData = $0.availableData
        Task { @MainActor in data.append(availableData) }
    }

    expression()

    try await Task.sleep(nanoseconds: 1_000_000)

    return data
//    return "Hello, World!".data(using: .utf8)!
}
