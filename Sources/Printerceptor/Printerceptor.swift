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
        let standardOutput = FileHandle.standardOutput.fileDescriptor
        let originalStandardOutput = dup(standardOutput)

        let intercepted = Pipe()
        let interceptedOutput = intercepted.fileHandleForWriting.fileDescriptor

        redirectFileDescriptor(standardOutput, to: interceptedOutput)

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

        redirectFileDescriptor(standardOutput, to: originalStandardOutput)
        try intercepted.fileHandleForReading.close()

        return data
    }

    await Task.yield()

    expression()
    print(semaphore)

    return try await data.value
}

private func redirectFileDescriptor(_ source: Int32, to destination: Int32) {
    dup2(destination, source)
}
