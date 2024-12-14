import Foundation

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
@MainActor
public func interceptStdout(_ expression: () -> Void) async throws -> String {
    let captured: Data = try await interceptStdout(expression)

    return .init(data: captured, encoding: .utf8) ?? ""
}

@MainActor
internal func interceptStdout(_ expression: () -> Void) async throws -> Data {
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
}
