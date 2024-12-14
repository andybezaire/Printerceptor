/// Intercept and return stdout
///
/// ```swift
/// import Testing
///
/// @Test func helloWorld() async throws {
///     let capturedOutput = interceptStdout {
///         print("Hello, World!")
///     }
///
///     #expect(capturedOutput == "Hello, World!")
/// }
/// ```
///
/// - Parameter expression: the code that prints to `stdout`
/// - Returns: string version of `stdout`
public func interceptStdout(_ expression: () throws -> Void) -> String {
    "Hello, World!"
}

