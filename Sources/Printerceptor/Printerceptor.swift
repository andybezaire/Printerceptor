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
    let interceptedOut = intercepted.fileHandleForWriting.fileDescriptor

    let standardOutput = FileHandle.standardOutput.fileDescriptor
    let restoreForStandardOutput = dup(standardOutput)

    dup2(interceptedOut, standardOutput)

    let data = Task {
        var data: Data = .init()

        for try await availableData in intercepted.fileHandleForReading.bytes {
            data.append(availableData)
        }

        return data
    }

    expression()

    try await Task.sleep(nanoseconds: 1_000_000)

    dup2(restoreForStandardOutput, standardOutput)
    try intercepted.fileHandleForReading.close()

    return try await data.value
}
