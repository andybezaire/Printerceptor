import Testing
import Printerceptor

@Test
func determineFunctionSignature() async throws {
    let sut = "Hello, World!"

    let capturedOutput = interceptStdout {
        print(sut)
    }

    #expect(capturedOutput == "Hello, World!")
}
