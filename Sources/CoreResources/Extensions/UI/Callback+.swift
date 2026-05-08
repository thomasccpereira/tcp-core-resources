import Foundation

public typealias VoidCallback = @MainActor () -> Void
public typealias AsyncVoidCallback = @MainActor () async -> Void
public typealias AsyncThrowsVoidCallback = @MainActor () async throws -> Void
