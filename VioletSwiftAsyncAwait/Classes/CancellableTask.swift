import Foundation

public typealias CancellableTask<T> = (
    _ completion: @escaping (T?, Error?) -> (),
    _ cancellation: Cancellation) -> ()
