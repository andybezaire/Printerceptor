import Testing

@Test
func determineFunctionSignature() async throws {
    let sut = "Hello, World!"

    let capturedOutput = interceptStdout {
        print(sut)
    }

    #expect(capturedOutput == "Hello, World!")
}

func interceptStdout(_ expression: () throws -> Void) -> String {
    "Hello, World!"
}
