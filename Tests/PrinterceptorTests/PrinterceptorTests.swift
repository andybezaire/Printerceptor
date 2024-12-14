import Testing
@testable import Printerceptor
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

    @Suite
    struct InterceptStdoutTests {
        @Test @MainActor
        func captureData() async throws {
            let sut = "Hello, World!"

            let intercepted: Data = try await interceptStdout {
                print(sut)
            }

            #expect(intercepted == .init([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33, 10]))
        }

        @Test @MainActor
        func noPrintCapturesEmptyData() async throws {
            let intercepted: Data = try await interceptStdout { }

            #expect(intercepted.isEmpty)
        }
    }
}
