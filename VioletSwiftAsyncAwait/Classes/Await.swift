import Foundation


public func await<T>(_ cancel: Cancellation, _ a: @escaping () -> CancellableTask<T>) throws -> T {
    return try await(a(), cancel: cancel)
}

public func await<T>(_ a: @escaping CancellableTask<T>, cancel: Cancellation) throws -> T {
    let semaphore = DispatchSemaphore(value: 0)
    var result:(value: T?, error: Error?)!
    if cancel.cancelled {
        throw TaskError.cancelled
    }
    let receipt = cancel.onCancel {
        result = (nil, TaskError.cancelled)
        semaphore.signal()
    }
    a({ v, e in
        result = (v, e)
        semaphore.signal()
    }, cancel)
    semaphore.wait()
    cancel.remove(receipt)
    if let value = result.value {
        return value
    }
    throw result.error ?? TaskError.noResult
}

public func await<T>(_ a: @escaping () -> FailableTask<T>) throws -> T {
    return try await(a())
}

public func await<T>(_ a: @escaping FailableTask<T>) throws -> T {
    let semaphore = DispatchSemaphore(value: 0)
    var result:(value: T?, error: Error?)!
    a { v, e in
        result = (v, e)
        semaphore.signal()
    }
    semaphore.wait()
    if let value = result.value {
        return value
    }
    throw result.error ?? TaskError.noResult
}

public func await<T>(_ a: @escaping () -> Task<T>) -> T {
    return await(a())
}

public func await<T>(_ a: @escaping Task<T>) -> T {
    let semaphore = DispatchSemaphore(value: 0)
    var value: T!
    a({ v in
        value = v
        semaphore.signal()
    })
    semaphore.wait()
    return value
}


