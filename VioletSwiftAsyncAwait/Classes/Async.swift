import Foundation

public func async<T>(_ dispatchPolicy: DispatchPolicy = .onCurrentQueue ,_ body: @escaping (Cancellation) throws -> T) -> CancellableTask<T> {
    return { completion, cancel in
        dispatchPolicy.dispatch {
            do {
                if cancel.cancelled {
                    throw TaskError.cancelled
                }
                let value = try body(cancel)
                completion(value, nil)
            }
            catch { completion(nil, error) }
        }
    }
}

public func async<T>(_ dispatchPolicy: DispatchPolicy = .onCurrentQueue ,_ body: @escaping () throws -> T) -> FailableTask<T> {
    return { completion in
        dispatchPolicy.dispatch {
            do { completion(try body(), nil) }
            catch { completion(nil, error) }
        }
    }
}

public func async<T>(_ dispatchPolicy: DispatchPolicy = .onCurrentQueue ,_ body: @escaping () -> T) -> Task<T> {
    return { completion in
        dispatchPolicy.dispatch {
            completion(body())
        }
    }
}
