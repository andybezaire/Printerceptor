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
internal func interceptStdout(semaphore: String = "!!eNd!oF!fILe!!!", _ expression: () -> Void) async throws -> Data {
    let data = Task {
        let intercepted = Pipe()
        let interceptedOut = intercepted.fileHandleForWriting.fileDescriptor

        let standardOutput = FileHandle.standardOutput.fileDescriptor
        let restoreForStandardOutput = dup(standardOutput)

        dup2(interceptedOut, standardOutput)

        var data: Data = .init()

        let semaphore: [UInt8] = Array(semaphore.utf8)
        var buffer: [UInt8] = []

        for try await availableData in intercepted.fileHandleForReading.bytes {
            buffer.append(availableData)
            if buffer.count > semaphore.count {
                data.append(buffer.removeFirst())

            }

            if buffer == semaphore { break }
        }

        dup2(restoreForStandardOutput, standardOutput)
        try intercepted.fileHandleForReading.close()

        return data
    }

    await Task.yield()

    expression()
    print(semaphore)

    return try await data.value
}
