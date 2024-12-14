import Testing
import Printerceptor

@Test
func determineFunctionSignature() async throws {
    let sut = "Hello, World!"

    let captured: String = interceptStdout {
        print(sut)
    }

    #expect(captured == "Hello, World!")
}
